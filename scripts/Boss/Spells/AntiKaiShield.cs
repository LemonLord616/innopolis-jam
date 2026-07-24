using System.Collections;
using HCoroutines;
using System.IO;
using Godot;

public partial class AntiKaiShield : Area3D
{
	[Export] private MeshInstance3D mesh;
	[Export] private float lifeTime = 1f;
	[Export] private float coolDowm = 1f;
	[Export] private SpellPacifier self;
	[Export] private BookWalker bookWalker;

	public bool IsActive => _delay != null;

	private Coroutine _delay;

	public override void _Ready()
	{
		BodyEntered += OnCollisionEnter;
	}

	public override void _ExitTree()
	{
		base._ExitTree();
		BodyEntered -= OnCollisionEnter;
	}

	private void OnCollisionEnter(Node3D body)
	{
		if (!bookWalker.BossProgress.HasOpened(bookWalker.CountRespawn, Path.GetFileNameWithoutExtension(self.ResourcePath))) return;

		if (_delay == null) _delay = Co.Run(Delay);

		if (mesh.Visible) body.Set("direction", Vector3.Down);
	}

	private IEnumerator Delay()
	{
		mesh.Visible = true;
		yield return Co.Delay(lifeTime);
		mesh.Visible = false;
		yield return Co.Delay(coolDowm);
		_delay = null;
	}
}