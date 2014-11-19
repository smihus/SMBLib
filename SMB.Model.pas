unit SMB.Model;

interface
uses
  Data.DB, Data.Win.ADODB, SMB.DBUtils,
  DBConnection, System.SysUtils, SMB.ConnectionManager;
type
  TModel = class
  private
    FConnectionManager: IConnectionManager;
    FADOQuery         : TADOQuery;
    FDataSource       : TDataSource;
  public
    constructor Create(ConnectionManager: IConnectionManager); virtual;
    destructor Destroy; override;
    property DataSource: TDataSource read FDataSource;
  protected
    procedure ExecQuery(SQLQuery: String);
    procedure SetDisplayLabel(FieldName: String; FieldLabel: String);

  end;
implementation

{ TModel }

constructor TModel.Create(ConnectionManager: IConnectionManager);
begin
  FConnectionManager  := ConnectionManager;
  CreateADOQueryAndDataSource(nil, FConnectionManager.Connection['EOGH'],
    '', FADOQuery, FDataSource);
end;

destructor TModel.Destroy;
begin
  if Assigned(FDataSource) then
    FreeAndNil(FDataSource);
  if Assigned(FADOQuery) then
    FreeAndNil(FADOQuery);
  inherited;
end;

procedure TModel.ExecQuery(SQLQuery: String);
begin
  with FADOQuery do
  begin
    if Active then
      Active := False;
    SQL.Text := SQLQuery;
    Active := True;
  end;
end;

procedure TModel.SetDisplayLabel(FieldName, FieldLabel: String);
begin
  FADOQuery.FieldByName(FieldName).DisplayLabel := FieldLabel;
end;

end.
