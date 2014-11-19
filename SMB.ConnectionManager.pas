unit SMB.ConnectionManager;

interface
uses
  Data.Win.ADODB;
type
  IConnectionManager = interface
  ['{188368B3-1113-40A8-B2B1-1E7DFE51247F}']
    function GetConnection(const ConnectionName: String): TADOConnection;
    procedure AddConnection(const ConnectionName: String;
    const aProvider: String; const aServer: string; const aDBName: String;
    const aLogin: String; const aPassword: String);
    procedure RemoveConnection(const ConnectionName: String);
    property Connection[const ConnectionName: String]: TADOConnection read GetConnection;
  end;

var
  ConnectionManager: IConnectionManager;

implementation

uses
  System.SysUtils, SMB.DBUtils, System.Generics.Collections;

type
  TConnectionManager = class(TInterfacedObject, IConnectionManager)
  private
    FConnections: TDictionary<string, TADOConnection>;
    function GetConnection(const ConnectionName: String): TADOConnection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddConnection(const ConnectionName: String;
      const aProvider: String; const aServer: string; const aDBName: String;
      const aLogin: String; const aPassword: String);
    procedure RemoveConnection(const ConnectionName: String);
    property Connection[const ConnectionName: String]: TADOConnection read GetConnection;
  end;

{ TConnectionManager }

procedure TConnectionManager.AddConnection(const ConnectionName: String;
  const aProvider: String; const aServer: string; const aDBName: String;
  const aLogin: String; const aPassword: String);
var
  Connection: TADOConnection;
begin
  Connection := CreateADOConnection(aProvider, aServer, aDBName, aLogin, aPassword);
  FConnections.Add(ConnectionName, Connection);
end;

constructor TConnectionManager.Create;
begin
  FConnections := TDictionary<string, TADOConnection>.Create;
end;

destructor TConnectionManager.Destroy;
begin
  FreeAndNil(FConnections);
  inherited;
end;

function TConnectionManager.GetConnection(
  const ConnectionName: String): TADOConnection;
begin
  if not FConnections.TryGetValue(ConnectionName, Result) then
    Result := nil;
end;

procedure TConnectionManager.RemoveConnection(const ConnectionName: String);
begin
  FConnections.Remove(ConnectionName);
end;

initialization
  ConnectionManager := TConnectionManager.Create;

end.
