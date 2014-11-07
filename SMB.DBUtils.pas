unit SMB.DBUtils;

interface

uses
  System.Classes, Data.DB, Data.Win.ADODB;

function CreateADOQuery(Owner: TComponent; const Connection:TADOConnection;
  const QueryString: String):TADOQuery;

procedure CreateADOQueryAndDataSource(Owner: TComponent; const Connection:TADOConnection;
  const QueryString: String; var ADOQuery:TADOQuery; var DataSource: TDataSource);

implementation

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
end.
