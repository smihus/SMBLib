unit SMB.FIAS;

interface
uses
  System.SysUtils, Data.Win.ADODB;
type
  EInvalidFiasGUID = class (Exception);

  TAddressElements = record
  //House
    PostalCode  : string[6];      // Почтовый индекс
    BuildNum    : string[10];     // Номер корпуса
    HouseNum    : string[20];     // Номер дома
    ESTStatName : string[20];     // Признак владения (Не определено, Владение, Дом, Владение)
    STRStatName : string[20];     // Признак строения (Не определено, Строение, Сооружение, Литер)
    IFNSFL      : string[4];      // Код ИФНС ФЛ
    IFNSUL      : string[4];      // Код ИФНС ЮЛ
    OKATO       : string[11];     // ОКАТО
    OKTMO       : string[11];     // ОКТМО
    StrucNum    : string[10];     // Номер строения
    TerrIFNSFL  : string[4];      // Код территориального участка ИФНС ФЛ
    TerrIFNSUL  : string[4];      // Код территориального участка ИФНС ЮЛ
    NormDocID     : string[36];   // ИД нормативного документа
    class operator Equal(a, b: TAddressElements): Boolean;
  end;

const
  EmptyAddressElement: TAddressElements = (
    PostalCode  : '';
    BuildNum    : '';
    HouseNum    : '';
    ESTStatName : '';
    STRStatName : '';
    IFNSFL      : '';
    IFNSUL      : '';
    OKATO       : '';
    OKTMO       : '';
    StrucNum    : '';
    TerrIFNSFL  : '';
    TerrIFNSUL  : '';
    NormDocID   : '';
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
    function FiasToStr(const FiasGUID: String): String;
    function FiasToRecAddr(const FiasGUID: string; const OnDate: TDate = 0): TAddressElements;
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

function TSMBFias.FiasToRecAddr(const FiasGUID: string; const OnDate: TDate = 0): TAddressElements;
var
  OnDateStr: String;
begin
  if not IsFiasGUID(FiasGUID) then
  begin
    Result := EmptyAddressElement;
    Exit;
  end;


    with FQuery do
    begin
      SQL.Text :=
        'select ' +
          'h.POSTALCODE, ' +
          'h.BUILDNUM, ' +
          'h.HOUSENUM, ' +
          '(select NAME from ESTSTAT where ESTSTATID = h.ESTSTATUS) as ESTSTATNAME, ' +
          '(select NAME from STRSTAT where STRSTATID = h.STRSTATUS) as STRSTATNAME, ' +
          'h.IFNSFL, ' +
          'h.IFNSUL, ' +
          'h.OKATO, ' +
          'h.OKTMO, ' +
          'h.STRUCNUM, ' +
          'h.TERRIFNSFL, ' +
          'h.TERRIFNSUL, ' +
          'h.NORMDOC ' +
        'from HOUSE h ' +
        'where ' +
          'h.HOUSEGUID = :FiasGUID ';

      if OnDate = 0 then
        SQL.Text := SQL.Text +
          'and h.UPDATEDATE = (select max(UPDATEDATE) from house where HOUSEGUID = h.HOUSEGUID)'
      else
      begin
        OnDateStr := QuotedStr(DateToStr(OnDate));
        SQL.Text := SQL.Text + 'and h.STARTDATE <= ' + OnDateStr +
          ' and h.ENDDATE > ' + OnDateStr;
      end;

      Parameters.ParamValues['FiasGUID'] := FiasGUID;
      Active := True;
    end;

  if FQuery.IsEmpty then
    Result := EmptyAddressElement
  else
    with Result, FQuery do
    begin
      PostalCode  := FieldValues['POSTALCODE'];
      BuildNum    := FieldValues['BUILDNUM'];
      HouseNum    := FieldValues['HOUSENUM'];
      ESTStatName := FieldValues['ESTSTATNAME'];
      STRStatName := FieldValues['STRSTATNAME'];
      IFNSFL      := FieldValues['IFNSFL'];
      IFNSUL      := FieldValues['IFNSUL'];
      OKATO       := FieldValues['OKATO'];
      OKTMO       := FieldValues['OKTMO'];
      StrucNum    := FieldValues['STRUCNUM'];
      TerrIFNSFL  := FieldValues['TERRIFNSFL'];
      TerrIFNSUL  := FieldValues['TERRIFNSUL'];
      NormDocID   := FieldValues['NORMDOC'];
    end;
end;

function TSMBFias.FiasToStr(const FiasGUID: String): String;
begin
  if not IsFiasGUID(FiasGUID) then
  begin
    Result := '';
    Exit;
  end;

  Result := '';
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

class operator TAddressElements.Equal(a, b: TAddressElements): Boolean;
begin
  Result := (a.PostalCode = b.PostalCode) and
            (a.BuildNum     = b.BuildNum) and
            (a.HouseNum     = b.HouseNum) and
            (a.ESTStatName  = b.ESTStatName) and
            (a.STRStatName  = b.STRStatName) and
            (a.IFNSFL       = b.IFNSFL) and
            (a.IFNSUL       = b.IFNSUL) and
            (a.OKATO        = b.OKATO) and
            (a.OKTMO        = b.OKTMO) and
            (a.StrucNum     = b.StrucNum) and
            (a.TerrIFNSFL   = b.TerrIFNSFL) and
            (a.TerrIFNSUL   = b.TerrIFNSUL) and
            (a.NormDocID    = b.NormDocID);
end;

end.
