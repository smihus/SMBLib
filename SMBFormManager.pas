unit SMBFormManager;

interface
uses
  System.Classes, Vcl.Menus, SMBBaseMDIChild, System.Generics.Collections;
type
  IFormManager = interface
  ['{7E89B366-4516-446B-8A52-854791CAD34A}']
    function CreateForm(const Name: String; Owner: TComponent): TSMBBaseMDIChild;
    procedure RegisterForm(const NameForm: String;
      MDIChild: TSMBBaseMDIChildClass; const MenuItemName: String = '');
    procedure AppendTo(Menu: TMainMenu);
  end;

var
  FormManager: IFormManager;

implementation

uses
  System.SysUtils, SMB.Model;

type
  TFormManager = class(TInterfacedObject, IFormManager)
  private
    FFormList         : TDictionary<String, TSMBBaseMDIChildClass>;
    FMenuItemNameList : TDictionary<String, String>;
    function AppendItemTo(var MenuItem: TMenuItem;
      const MenuItemName: String): TMenuItem;
    procedure OnClickItem(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    function CreateForm(const Name: String; Owner: TComponent): TSMBBaseMDIChild;
    procedure RegisterForm(const NameForm: String;
      MDIChild: TSMBBaseMDIChildClass; const MenuItemName: String = '');
    procedure AppendTo(Menu: TMainMenu);
  end;

{ TSMBFormManager }

function TFormManager.AppendItemTo(var MenuItem: TMenuItem;
  const MenuItemName: String): TMenuItem;
var
  Item: TMenuItem;
begin
  Item := MenuItem.Find(MenuItemName);
  if not Assigned(Item) then
  begin
    Item := TMenuItem.Create(MenuItem);
    Item.Caption := MenuItemName;
    MenuItem.Add(Item);
  end;
  Result := Item;
end;

procedure TFormManager.AppendTo(Menu: TMainMenu);
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
      CurrentItem := AppendItemTo(CurrentItem, Trim(MenuItemNames[i]));
    CurrentItem.Name    := Key;
    CurrentItem.OnClick := OnClickItem;
  end;
end;

constructor TFormManager.Create;
begin
  FFormList         := TDictionary<String, TSMBBaseMDIChildClass>.Create;
  FMenuItemNameList := TDictionary<String, String>.Create;
end;

function TFormManager.CreateForm(const Name: String; Owner: TComponent): TSMBBaseMDIChild;
var
  SMBBaseMDIChildClass: TSMBBaseMDIChildClass;
begin
  if FFormList.TryGetValue(Name, SMBBaseMDIChildClass) then
    Result := SMBBaseMDIChildClass.Create(Owner)
  else
    raise Exception.Create('Программа пытается вызвать незарегистрированную форму!!! Обратитесь к разработчику.');
end;

destructor TFormManager.Destroy;
begin
  FreeAndNil(FFormList);
  FreeAndNil(FMenuItemNameList);
  inherited;
end;

procedure TFormManager.OnClickItem(Sender: TObject);
var
  MenuItem: TMenuItem;
begin
  MenuItem := (Sender as TMenuItem);
  CreateForm(MenuItem.Name, MenuItem);
end;

procedure TFormManager.RegisterForm(const NameForm: String;
  MDIChild: TSMBBaseMDIChildClass; const MenuItemName: String = '');
begin
  FFormList.Add(NameForm, MDIChild);
  if Trim(MenuItemName) <> '' then
    FMenuItemNameList.Add(Trim(NameForm), Trim(MenuItemName));
end;

initialization
  FormManager := TFormManager.Create;

end.
