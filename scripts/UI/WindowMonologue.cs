using System.Collections;
using HCoroutines;
using Godot;

public partial class WindowMonologue : Control
{
	[Export] private MonoSelectorData data;
	[Export] private Spawner spawner;
	[Export] private NinePatchRect rect;
	[Export] private Godot.Label name;
	[Export] private Godot.Label phrase;

	private Coroutine _visible;

	public override void _Ready()
	{
		_visible = Co.Run(VisibleUpdate);
	}

	public override void _ExitTree()
	{
		_visible?.Kill();
	}


	private void SetPhrase()
	{
		var monologue = data.GetRandomMonologue();
		name.Text = monologue.Name;
		phrase.Text = monologue.GetRandomPhrase();
	}

	private IEnumerator VisibleUpdate()
	{
		if (spawner == null)
		{
			_visible?.Kill();
			yield return null;
		}

		while (true)
		{
			yield return Co.WaitUntil(spawner.IsInstanceBW);
			yield return Co.Wait(data.InVisibleDuration);
			SetPhrase();
			rect.Visible = true;

			yield return Co.Wait(data.VisibleDuration);
			
			rect.Visible = false;
		}
	}
}
