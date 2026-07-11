using System.Threading.Tasks;
using System;
using Godot;

public partial class WindowMonologue : Control
{
	[Export] private MonoSelectorData data;
	[Export] private Timer timer;
	[Export] private NinePatchRect rect;
	[Export] private Godot.Label name;
	[Export] private Godot.Label phrase;

	public override void _Ready()
	{
		VisibleUpdate();
	}

	private void SetPhrase()
	{
		var monologue = data.GetRandomMonologue();
		name.Text = monologue.Name;
		phrase.Text = monologue.GetRandomPhrase();
	}

	private async Task VisibleUpdate()
	{
		while (true)
		{
			timer.Start(data.InVisibleDuration);
			await ToSignal(timer, Timer.SignalName.Timeout);

            SetPhrase();
            rect.Visible = true;
			timer.Start(data.VisibleDuration);

            await ToSignal(timer, Timer.SignalName.Timeout);
            
            rect.Visible = false;
		}
	}
}