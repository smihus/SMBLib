unit SMB.DBUtils;

interface

uses
  System.Classes, Data.DB, Data.Win.ADODB;

function CreateADOConnection(const aProvider: String; const aServer: string;
  const aDBName: String; const aLogin: String; const aPassword: String): TADOConnection;

function CreateADOQuery(Owner: TComponent; const Connection:TADOConnection;
  const QueryString: String):TADOQuery;

procedure CreateADOQueryAndDataSource(Owner: TComponent; const Connection:TADOConnection;
  const QueryString: String; var ADOQuery:TADOQuery; var DataSource: TDataSource);

implementation
uses
  System.SysUtils, Vcl.Dialogs;
{ CreateADOQuery создает объект класса TADOQuery с одновременной инициализацией
  и выполнением запроса }
function CreateADOQuery(Owner: TComponent; const Connection:TADOConnection; const QueryString: String):TADOQuery;
var
  Query: TADOQuery;
begin
  Query           := TADOQuery.Create(Owner);
  Query.Connection:= Connection;
  Query.Active    := False;
  Query.SQL.Text  := QueryString;
  if not Query.SQL.Text.IsEmpty then
    Query.Active    := True;
  Result          := Query;
end;

{ CreateADOQueryAndDataSource создает объекты классов TADOQuery и TDataSource
  с одновременной инициализацией и выполнением запроса, а также связывает
  объект ADOQuery с объектом DataSource }
procedure CreateADOQueryAndDataSource(Owner: TComponent; const Connection:TADOConnection;
  const QueryString: String; var ADOQuery:TADOQuery; var DataSource: TDataSource);
begin
  ADOQuery          := CreateADOQuery(Owner, Connection, QueryString);
  DataSource        := TDataSource.Create(Owner);
  DataSource.DataSet:= ADOQuery;
end;

function CreateADOConnection(const aProvider: String; const aServer: string;
  const aDBName: String; const aLogin: String; const aPassword: String): TADOConnection;
begin
  Result := TADOConnection.Create(nil);
  Result.ConnectionString :='Persist Security Info=True;' +
    'Initial Catalog=' + aDBName + ';Data Source=' + aServer;
  Result.Provider       := aProvider;
  Result.LoginPrompt    := False;
  Result.KeepConnection := True;
  try
    Result.Open(aLogin, aPassword);
  except
    on E: Exception do
    begin
      FreeAndNil(Result);
      MessageDlg(
        'Ошибка соединения с базой данных: ' + E.Message + sLineBreak +
        'Обратитесь к администратору базы данных!', mtError, [mbOk], 0, mbOK);
      Halt(1);
    end;
  end;
end;

end.
