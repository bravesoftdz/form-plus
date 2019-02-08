unit Plus.Vcl.Frame;

interface

uses
  System.Classes,
  System.SysUtils,
  Vcl.AppEvnts,
  Vcl.Forms;

type
  TPlusFrameExtention = class(TComponent)
  private
    FOnFrameClose: TProc<TFrame>;
    FOnFrameReady: TProc<TObject>;
    FOnFrameIdle: TProc<TObject>;
    FFirstTimeIdle: Boolean;
    FApplicationEvents: TApplicationEvents;
    FFrame: TFrame;
    procedure SetOnFrameClose(const Value: TProc<TFrame>);
    procedure SetOnFrameIdle(const Value: TProc<TObject>);
    procedure SetOnFrameReady(const Value: TProc<TObject>);
    procedure SetFrame(const Value: TFrame);
    procedure EventOnFrameIdle(Sender: TObject; var Done: Boolean);
  public
    constructor Create(Owner: TComponent); override;
    procedure CloseFrame;
    property Frame: TFrame read FFrame write SetFrame;
    property OnFrameReady: TProc<TObject> read FOnFrameReady
      write SetOnFrameReady;
    property OnFrameIdle: TProc<TObject> read FOnFrameIdle write SetOnFrameIdle;
    property OnFrameClose: TProc<TFrame> read FOnFrameClose
      write SetOnFrameClose;
  end;

implementation

uses
  Vcl.Controls;

procedure TPlusFrameExtention.CloseFrame;
begin
  Frame.Visible := False;
  if Assigned(OnFrameClose) then
    OnFrameClose(Frame);
end;

constructor TPlusFrameExtention.Create(Owner: TComponent);
begin
  inherited;
  if (Owner = nil) or not(Owner is TFrame) then
    raise Exception.Create('Owner has to be TFrame');
  Frame := Owner as TFrame;
  FFirstTimeIdle := True;
  FApplicationEvents := TApplicationEvents.Create(Frame);
  FApplicationEvents.OnIdle := EventOnFrameIdle;
end;

procedure TPlusFrameExtention.EventOnFrameIdle(Sender: TObject;
  var Done: Boolean);
begin
  try
    if FFirstTimeIdle and  Assigned(OnFrameReady) then
      OnFrameReady(Frame);
    if Assigned(OnFrameIdle) then
      OnFrameIdle(Frame);
  finally
    FFirstTimeIdle := False;
    Done := True;
  end;
end;

procedure TPlusFrameExtention.SetFrame(const Value: TFrame);
begin
  FFrame := Value;
end;

procedure TPlusFrameExtention.SetOnFrameClose(const Value: TProc<TFrame>);
begin
  FOnFrameClose := Value;
end;

procedure TPlusFrameExtention.SetOnFrameIdle(const Value: TProc<TObject>);
begin
  FOnFrameIdle := Value;
end;

procedure TPlusFrameExtention.SetOnFrameReady(const Value: TProc<TObject>);
begin
  FOnFrameReady := Value;
end;

end.
