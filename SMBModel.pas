unit SMBModel;

interface
uses
  Data.DB, System.Generics.Collections, Data.Win.ADODB, SMB.DBUtils,
  DBConnection, System.SysUtils;
type
  TModel = class
  private
    FDataSources: TDictionary<String, TDataSource>;
    function GetDataSource(aName: String): TDataSource;
  public
    constructor Create;
    destructor Destroy; override;
    property DataSource[aName: String]: TDataSource read GetDataSource;
  protected
    procedure AddDataSource(const aName: String; const aSQLQuery: String;
      const aSQLParams: TParameters = nil);
  end;
implementation

{ TModel }

procedure TModel.AddDataSource(const aName, aSQLQuery: String;
  const aSQLParams: TParameters = nil);
var
  TempDS: TDataSource;
begin
  TempDS := TDataSource.Create(nil);
  TempDS.DataSet := CreateADOQuery(TempDS, DefaultADOConnection, aSQLQuery);
  if Assigned(aSQLParams) then
    (TempDS.DataSet as TADOQuery).Parameters := aSQLParams;

  FDataSources.AddOrSetValue(aName, TempDS);
end;

constructor TModel.Create;
begin
  FDataSources := TDictionary<String, TDataSource>.Create;
end;

destructor TModel.Destroy;
begin
  if Assigned(FDataSources) then
    FreeAndNil(FDataSources);
  inherited;
end;

function TModel.GetDataSource(aName: String): TDataSource;
begin
  Result := FDataSources[aName];
end;

end.
