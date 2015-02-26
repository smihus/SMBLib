unit SMB.FIAS;

interface
uses
  System.SysUtils, Data.Win.ADODB;
type
  EInvalidFiasGUID = class (Exception);

  PAddressElementRec = ^TAddressElementRec;

  TAddressElementRec = record
    AOLevel    : string;  //
    ParentGUID : string;  //
    ActStatus  : string;  //
    CurrStatus : string;  //
    ShortName  : string;  //
    FormalName : string;  //
    AreaCode   : string;  //
    CentStatus : string;  //
    CityCode   : string;  //
    Code       : string;  //
    IFNSFL     : string;  // Код ИФНС ФЛ
    IFNSUL     : string;  // Код ИФНС ЮЛ
    OffName    : string;  //
    OKATO      : string;  // ОКАТО
    OKTMO      : string;  // ОКТМО
    PlaceCode  : string;  //
    PlainCode  : string;  //
    PostalCode : string;  //
    RegionCode : string;  //
    StreetCode : string;  //
    TerrIFNSFL : string;  // Код территориального участка ИФНС ФЛ
    TerrIFNSUL : string;  // Код территориального участка ИФНС ЮЛ
    NormDocID  : string;  // ИД нормативного документа
    AddrElement: PAddressElementRec;
    class operator Equal(a, b: TAddressElementRec): Boolean;
    class operator Implicit(a: TAddressElementRec): String;
  end;

  THouseRec = record
    PostalCode        : string;     // Почтовый индекс
    BuildNum          : string;     // Номер корпуса
    HouseNum          : string;     // Номер дома
    ESTStatName       : string;     // Признак владения (Не определено, Владение, Дом, Домовладение)
    STRStatName       : string;     // Признак строения (Не определено, Строение, Сооружение, Литер)
    STRStatShortName  : string;     // Сокращенный признак строения (Не определено - '', Строение - стр, Сооружение - сооружение, Литер - литер)
    IFNSFL            : string;     // Код ИФНС ФЛ
    IFNSUL            : string;     // Код ИФНС ЮЛ
    OKATO             : string;     // ОКАТО
    OKTMO             : string;     // ОКТМО
    StrucNum          : string;     // Номер строения
    TerrIFNSFL        : string;     // Код территориального участка ИФНС ФЛ
    TerrIFNSUL        : string;     // Код территориального участка ИФНС ЮЛ
    NormDocID         : string;     // ИД нормативного документа
    AOGUID            : string;     // AOGUID вышестоящего по уровню адресного элемента (например для дома это ссылка на улицу)
    Address           : PAddressElementRec;
    class operator Equal(a, b: THouseRec): Boolean;
    class operator Implicit(a: THouseRec): String;
  end;

const
  EmptyHouseRec: THouseRec = (
    PostalCode        : '';
    BuildNum          : '';
    HouseNum          : '';
    ESTStatName       : '';
    STRStatName       : '';
    STRStatShortName  : '';
    IFNSFL            : '';
    IFNSUL            : '';
    OKATO             : '';
    OKTMO             : '';
    StrucNum          : '';
    TerrIFNSFL        : '';
    TerrIFNSUL        : '';
    NormDocID         : '';
    AOGUID            : '';
    Address           : nil;
  );

type
  TSMBFias = class
  private
    FFIASConnection: TADOConnection;
    FQuery: TADOQuery;
  public
    constructor Create(FIASConnection: TADOConnection);
    destructor Destroy; override;
    function IsFiasGUID(const FiasGUID: String): Boolean;
    function FiasToAddr(const FiasGUID: string; const OnDate: TDate = 0): THouseRec;
  end;

implementation

uses
  Data.DB;

{ TSMBFias }

constructor TSMBFias.Create(FIASConnection: TADOConnection);
begin
  FFIASConnection           := FIASConnection;
  FFIASConnection.Connected := True;
  FQuery                    := TADOQuery.Create(nil);
  FQuery.Connection         := FIASConnection;
end;

destructor TSMBFias.Destroy;
begin
  FreeAndNil(FQuery);
  inherited;
end;

function TSMBFias.FiasToAddr(const FiasGUID: string; const OnDate: TDate = 0): THouseRec;
var
  OnDateStr: String;
  CurrAddrElement: PAddressElementRec;
begin
  if not IsFiasGUID(FiasGUID) then
  begin
    Result := EmptyHouseRec;
    Exit;
  end;

  // Ищем дом
  with FQuery do
  begin
    SQL.Clear;
    if OnDate = 0 then
      SQL.Text := 'select * from LatestHouseInformation(:FiasGUID)'
    else
    begin
      OnDateStr := QuotedStr(DateToStr(OnDate));
      SQL.Text := 'select * from HouseInformationOnDate(:FiasGUID, ' + OnDateStr +')';
    end;

    Parameters.ParamValues['FiasGUID'] := FiasGUID;
    Active := True;
  end;

  if FQuery.IsEmpty then
  begin
    Result        := EmptyHouseRec;
    Result.AOGUID := FiasGUID;
  end
  else
    with Result, FQuery do
    begin
      PostalCode        := FieldByName('POSTALCODE').AsString;
      BuildNum          := FieldByName('BUILDNUM').AsString;
      HouseNum          := FieldByName('HOUSENUM').AsString;
      ESTStatName       := FieldByName('ESTSTATNAME').AsString;
      STRStatName       := FieldByName('STRSTATNAME').AsString;
      STRStatShortName  := FieldByName('STRSTATSHORTNAME').AsString;
      IFNSFL            := FieldByName('IFNSFL').AsString;
      IFNSUL            := FieldByName('IFNSUL').AsString;
      OKATO             := FieldByName('OKATO').AsString;
      OKTMO             := FieldByName('OKTMO').AsString;
      StrucNum          := FieldByName('STRUCNUM').AsString;
      TerrIFNSFL        := FieldByName('TERRIFNSFL').AsString;
      TerrIFNSUL        := FieldByName('TERRIFNSUL').AsString;
      NormDocID         := FieldByName('NORMDOC').AsString;
      AOGUID            := FieldByName('AOGUID').AsString;
      Address           := nil;
    end;

  // Ищем адрес дома или просто адрес, если передан FiasGUID адресного элемента
  with FQuery do
  begin
    SQL.Clear;
    if OnDate = 0 then
      SQL.Text := 'select * from LatestAddressInformation(:FiasGUID)'
    else
    begin
      OnDateStr := QuotedStr(DateToStr(OnDate));
      SQL.Text := 'select * from AddressInformationOnDate(:FiasGUID, ' + OnDateStr +')';
    end;

    if Result = EmptyHouseRec then
      Parameters.ParamValues['FiasGUID'] := FiasGUID
    else
      Parameters.ParamValues['FiasGUID'] := Result.AOGUID;

    Active := True;

    if IsEmpty then
      Result.Address := nil
    else
    with FQuery do
    begin
      New(Result.Address);
      CurrAddrElement := Result.Address;
      while True do
      begin
        with CurrAddrElement^ do
        begin
          AOLevel    := FieldByName('AOLevel').AsString;
          ParentGUID := FieldByName('ParentGUID').AsString;
          ActStatus  := FieldByName('ActStatus').AsString;
          CurrStatus := FieldByName('CurrStatus').AsString;
          ShortName  := FieldByName('ShortName').AsString;
          FormalName := FieldByName('FormalName').AsString;
          AreaCode   := FieldByName('AreaCode').AsString;
          CentStatus := FieldByName('CentStatus').AsString;
          CityCode   := FieldByName('CityCode').AsString;
          Code       := FieldByName('Code').AsString;
          IFNSFL     := FieldByName('IFNSFL').AsString;
          IFNSUL     := FieldByName('IFNSUL').AsString;
          OffName    := FieldByName('OffName').AsString;
          OKATO      := FieldByName('OKATO').AsString;
          OKTMO      := FieldByName('OKTMO').AsString;
          PlaceCode  := FieldByName('PlaceCode').AsString;
          PlainCode  := FieldByName('PlainCode').AsString;
          PostalCode := FieldByName('PostalCode').AsString;
          RegionCode := FieldByName('RegionCode').AsString;
          StreetCode := FieldByName('StreetCode').AsString;
          TerrIFNSFL := FieldByName('TerrIFNSFL').AsString;
          TerrIFNSUL := FieldByName('TerrIFNSUL').AsString;
          NormDocID  := FieldByName('NormDoc').AsString;
        end;

        Next;

        if Eof then
        begin
          CurrAddrElement.AddrElement := nil;
          Break;
        end
        else
        begin
          New(CurrAddrElement.AddrElement);
          CurrAddrElement := CurrAddrElement.AddrElement;
        end;
      end;
    end;
  end;
end;

function TSMBFias.IsFiasGUID(const FiasGUID: String): Boolean;
begin
  try
    StringToGUID('{' + FiasGUID + '}');
    Result := True;
  except
    Result := False;
    Exit;
  end;
end;

{ TAddressElements }

class operator THouseRec.Equal(a, b: THouseRec): Boolean;
begin
  Result := (a.PostalCode       = b.PostalCode) and
            (a.BuildNum         = b.BuildNum) and
            (a.HouseNum         = b.HouseNum) and
            (a.ESTStatName      = b.ESTStatName) and
            (a.STRStatName      = b.STRStatName) and
            (a.STRStatShortName = b.STRStatShortName) and
            (a.IFNSFL           = b.IFNSFL) and
            (a.IFNSUL           = b.IFNSUL) and
            (a.OKATO            = b.OKATO) and
            (a.OKTMO            = b.OKTMO) and
            (a.StrucNum         = b.StrucNum) and
            (a.TerrIFNSFL       = b.TerrIFNSFL) and
            (a.TerrIFNSUL       = b.TerrIFNSUL) and
            (a.NormDocID        = b.NormDocID) and
            (a.AOGUID           = b.AOGUID);

  if Assigned(a.Address) and Assigned(b.Address) then
    Result := Result and (a.Address^ = b.Address^)
  else
    Result := Result and (a.Address = b.Address)
end;

class operator THouseRec.Implicit(a: THouseRec): String;
var
  ShortTypeOfBuilding : String;
begin
  if a = EmptyHouseRec then
  begin
    Result := '';
    Exit;
  end;

  if a.PostalCode <> '' then
    Result := Result + a.PostalCode + ', ';

  if Assigned(a.Address) then
    Result := Result + a.Address^;

  if a.ESTStatName <> '' then
  begin
    if a.ESTStatName = 'Дом' then
      ShortTypeOfBuilding := 'д'
    else if a.ESTStatName = 'Владение' then
      ShortTypeOfBuilding := 'вл'
    else if a.ESTStatName = 'Домовладение' then
      ShortTypeOfBuilding := 'домовл'
    else
      ShortTypeOfBuilding := a.ESTStatName;

    Result := Result + ', ' + ShortTypeOfBuilding + ' ' + a.HouseNum;
  end;

  if a.BuildNum <> '' then
    Result := Result + ' корп ' + a.BuildNum;

  if a.STRStatShortName <> '' then
    Result := Result + ' ' + a.STRStatShortName + ' ' + a.StrucNum;
end;

{ TAddressRec }

class operator TAddressElementRec.Equal(a, b: TAddressElementRec): Boolean;
begin
  Result := (a.AOLevel      = b.AOLevel) and
            (a.ParentGUID   = b.ParentGUID) and
            (a.ActStatus    = b.ActStatus) and
            (a.CurrStatus   = b.CurrStatus) and
            (a.ShortName    = b.ShortName) and
            (a.FormalName   = b.FormalName) and
            (a.AreaCode     = b.AreaCode) and
            (a.CentStatus   = b.CentStatus) and
            (a.CityCode     = b.CityCode) and
            (a.Code         = b.Code) and
            (a.IFNSFL       = b.IFNSFL) and
            (a.IFNSUL       = b.IFNSUL) and
            (a.OffName      = b.OffName) and
            (a.OKATO        = b.OKATO) and
            (a.OKTMO        = b.OKTMO) and
            (a.PlaceCode    = b.PlaceCode) and
            (a.PlainCode    = b.PlainCode) and
            (a.PostalCode   = b.PostalCode) and
            (a.RegionCode   = b.RegionCode) and
            (a.StreetCode   = b.StreetCode) and
            (a.TerrIFNSFL   = b.TerrIFNSFL) and
            (a.TerrIFNSUL   = b.TerrIFNSUL) and
            (a.NormDocID    = b.NormDocID);

  if Assigned(a.AddrElement) and Assigned(b.AddrElement) then
    Result := Result and (a.AddrElement^ = b.AddrElement^)
  else
    Result := Result and (a.AddrElement = b.AddrElement);
end;

class operator TAddressElementRec.Implicit(a: TAddressElementRec): String;
begin
  Result := a.OffName + ' ' + a.ShortName;
  if Assigned(a.AddrElement) then
    Result := Result + ', ' + a.AddrElement^;
end;

end.