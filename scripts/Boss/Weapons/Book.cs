using System.Collections;
using HCoroutines;
using Godot;

public partial class Book : Area3D
{
	[Export] private float timeLife;
	[Export] private float moveUpDuration = .5f;
	[Export] private float curve = -2f;
	[Export] private Vector2 randomDurationInRun;

	private CharacterBody3D _player;
	private AttackData _attack;

	public void Init(AttackData attack, CharacterBody3D player, Vector3 upPoint)
	{
		_attack = attack;
		_player = player;
		BodyEntered += Entered;
		Co.Run(Action(upPoint));
	}

	private void Entered(Node3D body)
	{
		if (ReferenceEquals(_player, body))
			Damage.SetDamage(_player, _attack.Damage, new(GlobalTransform.Basis.Z, _attack.HitForce));
	}

	private void Rotate(Vector3 target, double delta)
	{
		var direction = target - GlobalPosition;
		direction.Y = 0;

		if (direction != Vector3.Zero)
		{
			var targetAngle = Mathf.Atan2(direction.X, direction.Z);
			var currentRotation = Rotation;

			currentRotation.Y = Mathf.LerpAngle(currentRotation.Y, targetAngle, _attack.Speed * (float)delta);
			Rotation = currentRotation;
		}
	}

	private IEnumerator Action(Vector3 upPoint)
	{
		var timeElapsed = 0.0f;
		var startPos = GlobalPosition;
		var endPos = upPoint;
		var toRun = 0f;
		var toRunEnd = (float)GD.RandRange(randomDurationInRun.X, randomDurationInRun.Y);
		var life = 0f;

		while (timeElapsed < moveUpDuration)
		{
			timeElapsed += (float)GetProcessDeltaTime();

			var progress = Mathf.Clamp(timeElapsed / moveUpDuration, 0.0f, 1.0f);

			var smoothProgress = Mathf.Ease(progress, curve: curve);

			GlobalPosition = startPos.Lerp(endPos, smoothProgress);
			yield return null;
		}

		while (toRun < toRunEnd)
		{
			toRun += (float)GetProcessDeltaTime();
			Rotate(_player.GlobalPosition, GetPhysicsProcessDeltaTime());
			yield return null;
		}

		while (life < timeLife)
		{
			life += (float)GetProcessDeltaTime();
			GlobalPosition += GlobalTransform.Basis.Z * _attack.Speed * (float)GetPhysicsProcessDeltaTime();
			yield return null;
		}

		QueueFree();
	}
}