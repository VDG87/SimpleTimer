unit Forms.Main;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.ImageList,

  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Controls.Presentation,
  FMX.Edit,
  FMX.StdCtrls,
  FMX.ImgList
{$IFDEF MSWINDOWS}
  ,Winapi.MMSystem
{$ENDIF}
  ;


type
  TTimerEntity = class;

  TMainForm = class(TForm)
    pnlWorkspace: TPanel;
    edtTime: TEdit;
    btnRun: TButton;
    MainTimer: TTimer;
    pnlHeader: TPanel;
    btnAdd: TButton;
    btnWorkTime: TButton;
    btnChiliTime: TButton;
    icons: TImageList;
    Glyph1: TGlyph;
    Glyph2: TGlyph;
    Glyph3: TGlyph;
    ClosedTimer: TTimer;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure MainTimerTimer(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure edtTimeChange(Sender: TObject);
    procedure btnWorkTimeClick(Sender: TObject);
    procedure btnChiliTimeClick(Sender: TObject);
    procedure ClosedTimerTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);

  private
    FResSream: TResourceStream;
    FRunning: Boolean;
    FHour: Integer;
    FMinute: Integer;
    FSecond: Integer;

  public
    { Public declarations }
  end;


  TTimerEntity = class(TObject)    {* Таймер *}
  private
    FHour:   Integer;
    FMinute: Integer;
    FSecond: Integer;

    FIsRunning: Boolean;

  public
    constructor Create();
    destructor Destroy(); override;

    function GetView(): string;
    procedure SetTime(AHour: Integer; AMinute: Integer; ASecond: Integer);

    property IsRunning: Boolean read FIsRunning;
  end;


var
  MainForm: TMainForm;

//------------------------------------------------------------------------------
implementation

{$R *.fmx}
{$R resources.RES}


procedure TMainForm.btnAddClick(Sender: TObject);
begin
  //
end;


procedure TMainForm.btnChiliTimeClick(Sender: TObject);
begin
  if FRunning then
    Exit();

  FHour   := 0;
  FMinute := 10;
  FSecond := 00;

  edtTime.Text := Format('%.2u:%.2u:%.2u', [FHour, FMinute, FSecond]);
end;


procedure TMainForm.btnRunClick(Sender: TObject);
begin
  if FRunning then
  begin
    PlaySound(0, 0, SND_PURGE);

    FRunning := False;
    edtTime.Enabled := True;
    MainTimer.Enabled := False;
    ClosedTimer.Enabled := False;
    btnRun.Text := 'START';
    btnRun.FontColor := TAlphaColorRec.Limegreen;
  end
  else
  begin
    FRunning := True;
    edtTime.Enabled := False;
    MainTimer.Enabled := True;
    btnRun.Text := 'STOP';
    btnRun.FontColor := TAlphaColorRec.Red;
  end;
end;


procedure TMainForm.btnWorkTimeClick(Sender: TObject);
begin
  if FRunning then
    Exit();

  FHour   := 0;
  FMinute := 59;
  FSecond := 59;

  edtTime.Text := Format('%.2u:%.2u:%.2u', [FHour, FMinute, FSecond]);
end;


procedure TMainForm.Button1Click(Sender: TObject);
begin
  if FRunning then
    Exit();

  FHour   := 0;
  FMinute := 03;
  FSecond := 00;

  edtTime.Text := Format('%.2u:%.2u:%.2u', [FHour, FMinute, FSecond]);
end;


procedure TMainForm.Button2Click(Sender: TObject);
begin
  if FRunning then
    Exit();

  FHour   := 0;
  FMinute := 30;
  FSecond := 00;

  edtTime.Text := Format('%.2u:%.2u:%.2u', [FHour, FMinute, FSecond]);
end;


procedure TMainForm.Button3Click(Sender: TObject);
begin
  if FRunning then
    Exit();

  FHour   := 0;
  FMinute := 05;
  FSecond := 00;

  edtTime.Text := Format('%.2u:%.2u:%.2u', [FHour, FMinute, FSecond]);
end;


procedure TMainForm.ClosedTimerTimer(Sender: TObject);
begin
  btnRunClick(nil);
end;


procedure TMainForm.edtTimeChange(Sender: TObject);
var
  list: TStringList;

begin
  if FRunning then
    Exit();

  list := TStringList.Create();
  try
    list.LineBreak := ':';
    list.Text := edtTime.Text;

    if list.Count = 3 then
    begin
      Integer.TryParse(list[0], FHour);
      Integer.TryParse(list[1], FMinute);
      Integer.TryParse(list[2], FSecond);
    end
    else
    begin
      //ShowMessage('Неверно значение');
    end;

  finally
    list.Free();
  end;
end;


procedure TMainForm.FormCreate(Sender: TObject);
begin
  FHour   := 0;
  FMinute := 59;
  FSecond := 59;

  edtTime.Text := Format('%.2u:%.2u:%.2u', [FHour, FMinute, FSecond]);

  FResSream := TResourceStream.Create(HInstance, 'SOUND_ALARM', RT_RCDATA);
end;


procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if FRunning then
  begin
    PlaySound(0, 0, SND_PURGE);

    FRunning := False;
    MainTimer.Enabled := False;
    ClosedTimer.Enabled := False;
    btnRun.Text := 'START';
    btnRun.FontColor := TAlphaColorRec.Limegreen;
  end;

  FreeAndNil(FResSream);
end;


procedure TMainForm.MainTimerTimer(Sender: TObject);
var
  hResource: THandle;
  pData: Pointer;
  hFind, hRes: THandle;
  Song: PChar;

begin
  if FSecond = 0 then
  begin
    if FMinute = 0 then
    begin
      if FHour = 0 then
      begin
//        PlaySound('alarm.wav', 0, SND_ASYNC or SND_LOOP);

          SndPlaySound(FResSream.Memory, SND_MEMORY or SND_ASYNC or SND_LOOP);

//        hResource := LoadResource(hInstance, FindResource(hInstance, 'SOUND_ALARM', RT_RCDATA));
//        try
//          pData := LockResource(hResource);
//          PlaySound('SOUND_ALARM', 0, SND_ASYNC or SND_LOOP);
//          //PlaySound('SOUND_ALARM', 0, SND_RESOURCE or SND_ASYNC or SND_LOOP);
//
//        finally
//          FreeResource(hResource);
//        end;

        ClosedTimer.Enabled := True;
        MainTimer.Enabled := False;
        Exit();
      end
      else
      begin
        Dec(FHour);
      end;

      FMinute := 59;
    end
    else
    begin
      Dec(FMinute);
    end;

    FSecond := 59;
  end
  else
  begin
    Dec(FSecond);
  end;

  edtTime.Text := Format('%.2u:%.2u:%.2u', [FHour, FMinute, FSecond]);
end;


{ TTimerEntity }

constructor TTimerEntity.Create;
begin

end;


destructor TTimerEntity.Destroy;
begin
  PlaySound(0, 0, SND_PURGE);

  inherited;
end;


function TTimerEntity.GetView: string;
begin
  Result := Format('%.2u:%.2u:%.2u', [FHour, FMinute, FSecond]);
end;


procedure TTimerEntity.SetTime(AHour, AMinute, ASecond: Integer);
begin
  FHour   := AHour;
  FMinute := AMinute;
  FSecond := ASecond;
end;

end.
