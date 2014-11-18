unit SMBFormManager;

interface
uses
  System.Classes, Vcl.Menus, SMBBaseMDIChild, System.Generics.Collections;
type
  TSMBFormManager = class
  private
    FFormList         : TDictionary<String, TSMBBaseMDIChildClass>;
    FMenuItemNameList : TDictionary<String, String>;
    function AppendItemTo(var AMenuItem: TMenuItem;
      const AMenuItemName: String): TMenuItem;
    procedure OnClickItem(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    function CreateForm(const aName: String; aOwner: TComponent): TSMBBaseMDIChild;
    procedure RegisterForm(const ANameForm: String;
      AMDIChild: TSMBBaseMDIChildClass; const AMenuItemName: String = '');
    procedure AppendTo(Menu: TMainMenu);
  end;

var
  DefaultSMBFormManager: TSMBFormManager;

implementation

uses
  System.SysUtils;

{ TSMBFormManager }

function TSMBFormManager.AppendItemTo(var AMenuItem: TMenuItem;
  const AMenuItemName: String): TMenuItem;
var
  Item: TMenuItem;
begin
  Item := AMenuItem.Find(AMenuItemName);
  if not Assigned(Item) then
  begin
    Item := TMenuItem.Create(AMenuItem);
    Item.Caption := AMenuItemName;
    AMenuItem.Add(Item);
  end;
  Result := Item;
end;

procedure TSMBFormManager.AppendTo(Menu: TMainMenu);
var
  Enum: TDictionary<String, String>.TPairEnumerator;
  Key, Value: String;
  MenuItemNames: TArray<String>;
  i: Integer;
  CurrentItem: TMenuItem;
begin
  Enum := FMenuItemNameList.GetEnumerator;
  while Enum.MoveNext do
  begin
    Key           := Enum.Current.Key;
    Value         := Enum.Current.Value;
    MenuItemNames := Value.Split(['/']);
    CurrentItem   := Menu.Items;
    for i := 0 to Length(MenuItemNames)-1 do
      CurrentItem := AppendItemTo(CurrentItem, MenuItemNames[i]);
    CurrentItem.Name    := Key;
    CurrentItem.OnClick := OnClickItem;
  end;
end;

constructor TSMBFormManager.Create;
begin
  FFormList         := TDictionary<String, TSMBBaseMDIChildClass>.Create;
  FMenuItemNameList := TDictionary<String, String>.Create;
end;

function TSMBFormManager.CreateForm(const aName: String; aOwner: TComponent): TSMBBaseMDIChild;
var
  SMBBaseMDIChildClass: TSMBBaseMDIChildClass;
begin
  if FFormList.TryGetValue(aName, SMBBaseMDIChildClass) then
    Result := SMBBaseMDIChildClass.Create(aOwner)
  else
    raise Exception.Create('Программа пытается вызвать незарегистрированную форму!!! Обратитесь к разработчику.');
end;

destructor TSMBFormManager.Destroy;
begin
  FreeAndNil(FFormList);
  FreeAndNil(FMenuItemNameList);
  inherited;
end;

procedure TSMBFormManager.OnClickItem(Sender: TObject);
var
  MenuItem: TMenuItem;
begin
  MenuItem := (Sender as TMenuItem);
  CreateForm(MenuItem.Name, MenuItem);
end;

procedure TSMBFormManager.RegisterForm(const ANameForm: String;
  AMDIChild: TSMBBaseMDIChildClass; const AMenuItemName: String = '');
begin
  FFormList.Add(ANameForm, AMDIChild);
  if Trim(AMenuItemName) <> '' then
    FMenuItemNameList.Add(ANameForm, AMenuItemName);
end;

initialization
  DefaultSMBFormManager := TSMBFormManager.Create;

finalization
  FreeAndNil(DefaultSMBFormManager);

end.
