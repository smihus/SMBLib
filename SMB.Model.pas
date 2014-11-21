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
    destructor Destroy; override;
    property DataSource: TDataSource read FDataSource;
    constructor Create(ConnectionManager: IConnectionManager); virtual;
  protected
    procedure Init; virtual; abstract;
    procedure ExecQuery(SQLQuery: String);
    procedure SetFieldParameters(FieldName, FieldLabel: string; FieldWidth: Integer = 0);

  end;
implementation

{ TModel }

constructor TModel.Create(ConnectionManager: IConnectionManager);
begin
  FConnectionManager  := ConnectionManager;
  CreateADOQueryAndDataSource(nil, FConnectionManager.Connection['EOGH'],
    '', FADOQuery, FDataSource);
  Init;
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

procedure TModel.SetFieldParameters(FieldName, FieldLabel: string; FieldWidth: Integer = 0);
begin
  with FADOQuery.FieldByName(FieldName) do
  begin
    DisplayLabel := FieldLabel;
    if FieldWidth > 0 then
      DisplayWidth := FieldWidth;
  end;

end;

end.
