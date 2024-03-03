unit _foto_;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, Menus, ExtCtrls, Jpeg, Buttons, ComCtrls, IniFiles,
  Spin, MPlayer, MMSystem;

type
  Tfoto_ = class(TForm)
    MainMenu1: TMainMenu;
    esc1: TMenuItem;
    Timer1: TTimer;
    Panel1: TPanel;
    CheckBox1: TCheckBox;
    inapoi1: TMenuItem;
    inainte1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    inapoi2: TMenuItem;
    inainte2: TMenuItem;
    Panel2: TPanel;
    FileListBox1: TFileListBox;
    Panel3: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Image2: TImage;
    Image1: TImage;
    CheckBox2: TCheckBox;
    SpinEdit1: TSpinEdit;
    MediaPlayer1: TMediaPlayer;
    Panel5: TPanel;
    Panel4: TPanel;
    Panel6: TPanel;
    CheckBox3: TCheckBox;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    Timer2: TTimer;
    Timer3: TTimer;
    Label1: TLabel;
    BitBtn4: TBitBtn;
    TrackBar3: TTrackBar;
    procedure esc1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure inapoi1Click(Sender: TObject);
    procedure inainte1Click(Sender: TObject);
    Procedure IncarcareSetariIni;
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure TrackBar3Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  foto_: Tfoto_;

implementation

uses _Despre_;

{$R *.DFM}

Const Poz          :Integer=0;
      Pas          :Integer=1;
      Autoderulare :Integer=1;
      Informatii   :Integer=1;
      Muzica       :Integer=1;
      Interval     :Integer=4;
      Fisier_Muzica:String ='';

Var   DirectorAplicatie:String;

procedure SetVolume(const volL, volR: Word); 
var 
  hWO: HWAVEOUT;
  waveF: TWAVEFORMATEX; 
  vol: DWORD; 
begin 
  // init TWAVEFORMATEX 
  FillChar(waveF, SizeOf(waveF), 0); 
  // open WaveMapper = std output of playsound 
  waveOutOpen(@hWO, WAVE_MAPPER, @waveF, 0, 0, 0); 
  vol := volL + volR shl 16; 
  // set volume 
  waveOutSetVolume(hWO, vol); 
  waveOutClose(hWO);
end;

function GetFileDateTime(FileName: string): TDateTime;
var intFileAge: LongInt;
begin
  intFileAge := FileAge(FileName);
  if intFileAge = -1 then
    Result := 0
  else
    Result := FileDateToDateTime(intFileAge)
end;

function SoundCardAvailable: Boolean;
begin
  Result := WaveOutGetNumDevs > 0;
end;

Procedure Tfoto_.IncarcareSetariIni;
Var f:TIniFile;
Begin
  If FileExists(DirectorAplicatie+'setari.ini') Then
    Begin
      f:=TIniFile.Create(DirectorAplicatie+'setari.ini');
      Try
        //res:=f.ReadString('Section_Name','Key_Name','default value');
        Autoderulare :=f.ReadInteger('FOTO','Autoderulare ',Autoderulare );
        Informatii   :=f.ReadInteger('FOTO','Informatii   ',Informatii   );
        Muzica       :=f.ReadInteger('FOTO','Muzica       ',Muzica       );
        Interval     :=f.ReadInteger('FOTO','Interval     ',Interval     );
        Fisier_Muzica:=f.ReadString ('FOTO','Fisier muzica',Fisier_muzica);
      Finally
        f.Free;
      End;
    End
//  Else
//    SalvareSetariIni;
End;

//Procedure TFise_.SalvareSetariIni;
//Var f:TIniFile;
//Begin
//  f:=TIniFile.Create(DirectorAplicatie+'GESTIUNE.INI');
//  Try
//    //f.WriteString('Section_Name', 'Key_Name', 'String Value');
//    f.WriteInteger('FISA'    ,'Format data'      ,FormatDataFisa    );
//    f.WriteInteger('FISA'    ,'Tip stergere fisa',TipStergereFisa   );
//    f.WriteInteger('OPERATII','Format data'      ,FormatDataOperatii);
//    f.WriteInteger('RAPOARTE','Format data'      ,FormatDataRaport  );
//    f.WriteInteger('RAPOARTE','Tip raport'       ,TipRaport         );
//    f.WriteString ('AJUTOR'  ,'Operator'         ,Operator          );
//  Finally
//    f.Free;
//  End;
//End;

procedure Tfoto_.esc1Click(Sender: TObject);
begin
  application.terminate;
end;

procedure Tfoto_.FormCreate(Sender: TObject);
begin
  DirectorAplicatie:=ExtractFileDir(Application.ExeName);
  If DirectorAplicatie[Length(DirectorAplicatie)]<>'\' Then
    DirectorAplicatie:=DirectorAplicatie+'\';
  IncarcareSetariIni;
  If Not SoundCardAvailable Then
    Begin
      MessageDlg('Placa de sunet nedetectata!'#13#13+
                 'Aplicatia se inchide.',
                  mtWarning,[mbOk],0)
//      Application.Terminate;
    End;
  SpinEdit1.Value  :=Interval;
  SpinEdit1Change(Sender);
  CheckBox1.Checked:=Informatii  =1;
  CheckBox2.Checked:=Autoderulare=1;
  CheckBox2Click(Sender);
  //Timer1.Enabled :=Autoderulare=1;
  If Fisier_Muzica<>'' Then
    Begin
      With MediaPlayer1 Do
        Begin
          //showmessage(DirectorAplicatie+Fisier_Muzica);
          Filename:=DirectorAplicatie+Fisier_Muzica;
          Open;
        End;
      CheckBox3.Checked:=Muzica=1;
      CheckBox3Click(Sender);
      CheckBox3.Enabled:=True;
      TrackBar1.Enabled:=True;
      TrackBar2.Enabled:=True;
      Label1   .Enabled:=True;
    End
  Else
    Begin
      CheckBox3.Checked:=False;
      CheckBox3.Enabled:=False;
      TrackBar1.Enabled:=False;
      TrackBar2.Enabled:=False;
      Label1   .Enabled:=False;
    End;
  left:=0;
  top:=0;
  width:=screen.width;
  height:=screen.height;
  panel4.left:=panel5.width -panel4.width -3;//-20;//=688-129-20
  panel4.top :=panel5.height-panel4.height-3;//-20;//=425- 25-20
  panel6.left:=panel5.width -panel6.width -panel4.width-6;
  panel6.top :=panel5.height-panel6.height-3;
  filelistbox1.directory:=DirectorAplicatie;
  poz:=filelistbox1.items.capacity-1;
  if filelistbox1.items.capacity=0 then
    application.terminate
  else
    timer1timer(Sender);
  trackbar3.width:=(panel1.width div 2)-trackbar3.left-100;  
end;

procedure Tfoto_.Timer1Timer(Sender: TObject);
var xy:extended;
begin
  poz:=poz+pas;
  if poz>filelistbox1.items.capacity-1 then
    begin
      poz:=0;
    end;
  image2.picture.loadfromfile(filelistbox1.items[poz]);
  image1.picture:=image2.picture;
  trackbar3.Position:=poz;
  xy:=image2.width/image2.height;
  if image2.width<image2.height then
    begin
      image1.height:=panel2.height;
      image1.width:=round(image1.height*xy);
    end
  else
    begin
      image1.width:=panel2.width;
      image1.height:=round(image1.width/xy);
    end;
  image1.left:=(panel2.width-image1.width) div 2;;
  image1.top:=(panel2.height-image1.height) div 2;
  panel1.caption:='Foto '+inttostr(poz+1)+' din '+inttostr(filelistbox1.items.capacity);
  panel4.caption:=FormatDateTime('dd-mm-yyyy hh:nn',GetFileDateTime(DirectorAplicatie+filelistbox1.items[poz]));
  panel6.caption:=filelistbox1.items[poz];
end;

procedure Tfoto_.inapoi1Click(Sender: TObject);
var xy:extended;
begin
  CheckBox2.Checked:=False;
  CheckBox2Click(Sender);
  poz:=poz-pas;
  if poz<0 then
    begin
      poz:=filelistbox1.items.capacity-1;
    end;
  image2.picture.loadfromfile(filelistbox1.items[poz]);
  image1.picture:=image2.picture;
  trackbar3.Position:=poz;
  xy:=image2.width/image2.height;
  if image2.width<image2.height then
    begin
      image1.height:=panel2.height;
      image1.width:=round(image1.height*xy);
    end
  else
    begin
      image1.width:=panel2.width;
      image1.height:=round(image1.width/xy);
    end;
  image1.left:=(panel2.width-image1.width) div 2;;
  image1.top:=(panel2.height-image1.height) div 2;
  panel1.caption:='Foto '+inttostr(poz+1)+' din '+inttostr(filelistbox1.items.capacity);
  panel4.caption:=FormatDateTime('dd-mm-yyyy hh:nn',GetFileDateTime(DirectorAplicatie+filelistbox1.items[poz]));
  panel6.caption:=filelistbox1.items[poz];
end;

procedure Tfoto_.inainte1Click(Sender: TObject);
var xy:extended;
begin
  CheckBox2.Checked:=False;
  CheckBox2Click(Sender);
  poz:=poz+pas;
  if poz>filelistbox1.items.capacity-1 then
    begin
      poz:=0;
    end;
  image2.picture.loadfromfile(filelistbox1.items[poz]);
  image1.picture:=image2.picture;
  trackbar3.Position:=poz;
  xy:=image2.width/image2.height;
  if image2.width<image2.height then
    begin
      image1.height:=panel2.height;
      image1.width:=round(image1.height*xy);
    end
  else
    begin
      image1.width:=panel2.width;
      image1.height:=round(image1.width/xy);
    end;
  image1.left:=(panel2.width-image1.width) div 2;;
  image1.top:=(panel2.height-image1.height) div 2;
  panel1.caption:='Foto '+inttostr(poz+1)+' din '+inttostr(filelistbox1.items.capacity);
  panel4.caption:=FormatDateTime('dd-mm-yyyy hh:nn',GetFileDateTime(DirectorAplicatie+filelistbox1.items[poz]));
  panel6.caption:=filelistbox1.items[poz];
end;

procedure Tfoto_.CheckBox2Click(Sender: TObject);
begin
  timer1.enabled:=CheckBox2.Checked;
end;

procedure Tfoto_.CheckBox1Click(Sender: TObject);
begin
  Panel5.Visible:=CheckBox1.Checked;
  panel4.left:=panel5.width -panel4.width -3;//-20;//=688-129-20
  panel4.top :=panel5.height-panel4.height-3;//-20;//=425- 25-20
  panel6.left:=panel5.width -panel6.width -panel4.width-6;
  panel6.top :=panel5.height-panel6.height-3;
end;

procedure Tfoto_.SpinEdit1Change(Sender: TObject);
begin
  Timer1.Interval:=SpinEdit1.Value*1000;
end;

procedure Tfoto_.CheckBox3Click(Sender: TObject);
begin
  If Fisier_Muzica<>'' Then
    Begin
      If CheckBox3.Checked Then
        MediaPlayer1.Play
      Else
        MediaPlayer1.Stop;
      TrackBar1.Enabled:=CheckBox3.Checked;
      TrackBar2.Enabled:=CheckBox3.Checked;
      Label1.Enabled:=CheckBox3.Checked;
    End;
end;

procedure Tfoto_.TrackBar1Change(Sender: TObject);
begin
  SetVolume({ScrollBar2.Max-}TrackBar1.Position,{ScrollBar2.Max-}TrackBar1.Position);
end;

procedure Tfoto_.TrackBar2Change(Sender: TObject);
begin
  If Fisier_Muzica<>'' Then
    Begin
      If TrackBar2.Tag=0 Then
        With MediaPlayer1 Do
          Begin
            Pause;
            Position:=TrackBar2.Position;
            Play;
          End;
    End;
end;

procedure Tfoto_.Timer3Timer(Sender: TObject);
begin
  If Fisier_Muzica<>'' Then
    With MediaPlayer1 do
      If Position>Frames*10-10 then
        Play;
end;

procedure Tfoto_.Timer2Timer(Sender: TObject);
begin
  If Fisier_Muzica<>'' Then
    Begin
      TrackBar2.Tag      :=1;
      TrackBar2.Max      :=MediaPlayer1.Frames*10;
      TrackBar2.Position :=MediaPlayer1.Position;
      TrackBar2.Frequency:=Round(TrackBar2.Max/20);
      TrackBar2.Tag      :=0;
    End;
  TrackBar3.Max     :=FileListBox1.Items.Capacity-1;
  TrackBar3.Position:=poz;
end;

procedure Tfoto_.BitBtn4Click(Sender: TObject);
begin
  despre_.showmodal;
end;

procedure Tfoto_.TrackBar3Change(Sender: TObject);
var xy:Extended;
begin
  Poz:=TrackBar3.Position;
  image2.picture.loadfromfile(filelistbox1.items[poz]);
  image1.picture:=image2.picture;
  xy:=image2.width/image2.height;
  if image2.width<image2.height then
    begin
      image1.height:=panel2.height;
      image1.width:=round(image1.height*xy);
    end
  else
    begin
      image1.width:=panel2.width;
      image1.height:=round(image1.width/xy);
    end;
  image1.left:=(panel2.width-image1.width) div 2;;
  image1.top:=(panel2.height-image1.height) div 2;
  panel1.caption:='Foto '+inttostr(poz+1)+' din '+inttostr(filelistbox1.items.capacity);
  panel4.caption:=FormatDateTime('dd-mm-yyyy hh:nn',GetFileDateTime(DirectorAplicatie+filelistbox1.items[poz]));
  panel6.caption:=filelistbox1.items[poz];
end;

end.
