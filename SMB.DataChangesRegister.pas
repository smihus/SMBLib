unit SMB.DataChangesRegister;

interface

uses
  System.Generics.Collections;
type
  TDataChangeEvent = procedure (const DataName: String; const Value: Boolean) of object;

  TSMBDataChangesRegister = class
  private
    FDataChanges: TList<String>;
    FAfterDataChange: TDataChangeEvent;
    function GetChanged(DataName: String): Boolean;
    procedure SetChanged(DataName: String; const Value: Boolean);
    function GetDataChanged: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    property Changed[DataName: String]: Boolean read GetChanged write SetChanged; default;
    property DataChanged: Boolean read GetDataChanged;
    property AfterDataChange: TDataChangeEvent read FAfterDataChange write FAfterDataChange;
  end;

implementation

uses
  System.SysUtils;

{ TSMBDataChangesRegister }

constructor TSMBDataChangesRegister.Create;
begin
  FDataChanges := TList<String>.Create;
end;

destructor TSMBDataChangesRegister.Destroy;
begin
  FreeAndNil(FDataChanges);
  inherited;
end;

function TSMBDataChangesRegister.GetChanged(DataName: String): Boolean;
begin
  Result := FDataChanges.Contains(DataName);
end;

function TSMBDataChangesRegister.GetDataChanged: Boolean;
begin
  FDataChanges.Pack;
  Result := (FDataChanges.Count > 0);
end;

procedure TSMBDataChangesRegister.SetChanged(DataName: String;
  const Value: Boolean);
begin
  if not Value then
    FDataChanges.Remove(DataName)
  else if not FDataChanges.Contains(DataName) then
    FDataChanges.Add(DataName);

  if Assigned(FAfterDataChange) then
    FAfterDataChange(DataName, Value);
end;

end.
