using System.Collections;
using HCoroutines;
using UnityHFSM;
using Godot;

public partial class BookWalker : CharacterBody3D
{
	[Export] private NavigationAgent3D agent;
	[Export] private BWMesh bWMesh;
	[Export] public Stats Stats { get; private set; }
	[Export] private Area3D[] areas; // 0 - melle, 1 - range
	[Export] private Route[] routes;

	public float Gravity => (float)ProjectSettings.GetSetting("physics/3d/default_gravity");

	private CharacterBody3D _player;
	private Node3D _target;
	private Coroutine _readRoute;

	private StateMachine _sm;
	private KnockbackData _knockbackData;
	private const float DOT = .7f;//45 Degrees

	public void Init(Stats.StatsConfig config, BookWalkerData.BWStorages storages, Route[] routes, CharacterBody3D player)
	{
		Stats.Init(config);
		this.routes = routes;
		_player = player;
		_target = _player;
		Stats.OnDamageEv += () => _sm.Trigger(nameof(AnimationKeys.Damage));
		bWMesh.OnHitEv += () =>
		{
			var melee = storages.attackStorage.GetAttackToName(nameof(AnimationKeys.MeleeAttack));
			Damage.SetDamage(_player, melee.Damage, new KnockbackData(GlobalTransform.Basis.Z, melee.HitForce));
		};
		_sm = new StateMachine();

		//states
		_sm.AddState(nameof(AnimationKeys.Idle), onEnter => PlayAnimation(), onLogic =>
		{
			var fdelta = (float)GetPhysicsProcessDeltaTime();
			if (_player != null)
				Rotate(_player.GlobalPosition, fdelta);
			UseGravity(fdelta);
		});
		_sm.AddState(nameof(AnimationKeys.Walk), onEnter => PlayAnimation(), onLogic => Move((float)GetPhysicsProcessDeltaTime(), storages.stateStorage.GetStateToName(nameof(AnimationKeys.Walk)).SpeedAnimation));
		_sm.AddState(nameof(AnimationKeys.Run), onEnter => PlayAnimation(), onLogic => Move((float)GetPhysicsProcessDeltaTime(), Stats.SpeedModifier));
		_sm.AddState(nameof(AnimationKeys.MeleeAttack), onEnter =>
		{
			var state = storages.stateStorage.GetStateToName(nameof(AnimationKeys.MeleeAttack));
			bWMesh.AnimationPlayer.Play(_sm.ActiveStateName, customSpeed: state.SpeedAnimation);
		});
		_sm.AddState(nameof(AnimationKeys.MeleeAttackAOE), onEnter =>
		{
			var state = storages.stateStorage.GetStateToName(nameof(AnimationKeys.MeleeAttackAOE));
			bWMesh.AnimationPlayer.Play(_sm.ActiveStateName, customSpeed: state.SpeedAnimation);
		},
		onLogic =>
		{
			Move((float)GetPhysicsProcessDeltaTime(), storages.attackStorage.GetAttackToName(nameof(AnimationKeys.MeleeAttackAOE)).Speed);
			foreach (var body in areas[0].GetOverlappingBodies())
			{
				GD.PrintRich($"[color=green] b = {body.Name} [/color]");
				if (ReferenceEquals(body, _player))
				{
					var attack = storages.attackStorage.GetAttackToName(nameof(AnimationKeys.MeleeAttackAOE));
					Damage.SetDamage(_player, attack.Damage, new(GlobalTransform.Basis.Z, attack.HitForce));
				}
			}
		});
		_sm.AddState(nameof(AnimationKeys.RangeAttack), onEnter => PlayAnimation());
		_sm.AddState(nameof(AnimationKeys.Damage), onEnter => PlayAnimation());
		_sm.AddState(nameof(AnimationKeys.Spell_Anger), onEnter => PlayAnimation());
		_sm.AddState(nameof(AnimationKeys.Spell_FlyingProjectiles), onEnter => PlayAnimation());
		_sm.AddState(nameof(AnimationKeys.Spell_HailBooks), onEnter => PlayAnimation());
		_sm.AddState(nameof(AnimationKeys.Dead), onEnter => PlayAnimation());
		_sm.AddState(nameof(StateKeys.TurnDash), onEnter =>
		{
			var toPlayer = (_target.GlobalPosition - GlobalPosition).Normalized();
			_target = null;
			var myRight = GlobalTransform.Basis.X.Normalized();
			var myBackward = GlobalTransform.Basis.Z.Normalized();
			var fleeDirection = Vector3.Zero;
			var distanceMultiplier = 2f;
			var timeCodeAnimation = .4f;

			fleeDirection += myRight.Dot(toPlayer) > DOT ? -myRight : myRight;
			fleeDirection += myBackward.Dot(toPlayer) > DOT ? -myBackward : myBackward;
			fleeDirection = fleeDirection.Normalized();

			agent.TargetPosition = GlobalPosition + (fleeDirection * distanceMultiplier);
			if (myBackward.Dot(toPlayer) > 0f)
			{
				bWMesh.AnimationPlayer.Play(nameof(AnimationKeys.Run));
				timeCodeAnimation = 0f;
				bWMesh.AnimationPlayer.Seek(timeCodeAnimation, true);
			}
			else
			{
				bWMesh.AnimationPlayer.Play(nameof(AnimationKeys.RunBackwards));
				bWMesh.AnimationPlayer.Seek(timeCodeAnimation, true);
			}
			bWMesh.AnimationPlayer.Pause();
		}, onLogic => Move((float)GetPhysicsProcessDeltaTime(), Stats.SpeedModifier * storages.stateStorage.GetStateToName(nameof(StateKeys.TurnDash)).SpeedAnimation), onExit =>
		{
			_target = _player;
		});
		_sm.AddState(nameof(StateKeys.Knockback), onEnter =>
		{
			_target = null;
			agent.TargetPosition = GlobalPosition + (-_knockbackData.dir * (_knockbackData.force / 10f));
		}, onLogic => Move((float)GetPhysicsProcessDeltaTime(), Stats.SpeedModifier * storages.stateStorage.GetStateToName(nameof(StateKeys.Knockback)).SpeedAnimation)
		, onExit =>
		{
			_knockbackData = null;
			_target = _player;
		});

		//transitions
		_sm.AddTransitionFromAny(new Transition(null, nameof(AnimationKeys.Dead), condition => !Stats.IsAlive));
		_sm.AddTransition(nameof(AnimationKeys.Idle), nameof(AnimationKeys.MeleeAttackAOE), condition => IsWithinDistance(_target.GlobalPosition, areas[0].Scale.Z));
		_sm.AddTransition(nameof(AnimationKeys.Idle), nameof(AnimationKeys.Walk), condition => !IsWithinDistance(_target.GlobalPosition, areas[0].Scale.Z));
		_sm.AddTransition(nameof(AnimationKeys.Walk), nameof(AnimationKeys.Run), condition => !IsWithinDistance(_target.GlobalPosition, areas[1].Scale.Z));
		_sm.AddTransition(nameof(AnimationKeys.Walk), nameof(AnimationKeys.Idle), condition => IsWithinDistance(_target.GlobalPosition, areas[0].Scale.Z));
		_sm.AddTransition(nameof(AnimationKeys.Run), nameof(AnimationKeys.Walk), condition => IsWithinDistance(_target.GlobalPosition, areas[1].Scale.Z));
		_sm.AddTransition(nameof(AnimationKeys.MeleeAttack), nameof(AnimationKeys.MeleeAttack), condition => IsFinishAnimation(nameof(AnimationKeys.MeleeAttack)) && IsWithinDistance(_target.GlobalPosition, areas[0].Scale.Z) && IsForwardTarget(_target.GlobalPosition));
		_sm.AddTransition(nameof(AnimationKeys.MeleeAttack), nameof(StateKeys.TurnDash), condition => IsFinishAnimation(nameof(AnimationKeys.MeleeAttack)) && IsWithinDistance(_target.GlobalPosition, areas[0].Scale.Z) && !IsForwardTarget(_target.GlobalPosition));
		_sm.AddTransition(nameof(AnimationKeys.MeleeAttack), nameof(AnimationKeys.Idle), condition => IsFinishAnimation(nameof(AnimationKeys.MeleeAttack)) && !IsWithinDistance(_target.GlobalPosition, areas[0].Scale.Z));
		_sm.AddTransition(new TransitionAfter(nameof(StateKeys.TurnDash), nameof(AnimationKeys.Idle), storages.stateStorage.GetStateToName(nameof(StateKeys.TurnDash)).Duration));

		_sm.AddTriggerTransitionFromAny(nameof(AnimationKeys.Damage), new Transition(null, nameof(AnimationKeys.Damage), condition => Stats.IsAlive));
		_sm.AddTransition(new TransitionAfter(nameof(AnimationKeys.Damage), nameof(AnimationKeys.Idle), (float)bWMesh.AnimationPlayer.GetAnimation(nameof(AnimationKeys.Damage)).Length));
		_sm.AddTriggerTransitionFromAny(nameof(StateKeys.Knockback), new Transition(nameof(AnimationKeys.Damage), nameof(StateKeys.Knockback), condition => Stats.IsAlive));
		_sm.AddTransition(new Transition(nameof(StateKeys.Knockback), nameof(AnimationKeys.Idle), condition => agent.IsNavigationFinished()));
		_sm.AddTransition(new TransitionAfter(nameof(AnimationKeys.MeleeAttackAOE), nameof(AnimationKeys.Idle), storages.stateStorage.GetStateToName(nameof(AnimationKeys.MeleeAttackAOE)).Duration));

		_sm.SetStartState(nameof(AnimationKeys.Idle));
		_sm.Init();
	}

	public override void _Process(double delta)
	{
		base._Process(delta);
		GD.PrintRich($"[color=green]state = {_sm.ActiveStateName} [/color]");
		_sm.OnLogic();
		if (ReferenceEquals(_target, _player))
			agent.TargetPosition = _target.GlobalPosition;
	}

	public override void _ExitTree()
	{
		base._ExitTree();
		_readRoute?.Kill();
	}

	public void Knockback(KnockbackData data)
	{
		_knockbackData = data;
		_sm.Trigger(nameof(StateKeys.Knockback));
	}

	private bool IsForwardTarget(Vector3 target)
	{
		var toTarget = (target - GlobalPosition).Normalized();
		return GlobalTransform.Basis.Z.Dot(toTarget) > DOT;
	}

	private bool IsWithinDistance(Vector3 target, float distance)
	{
		return GlobalPosition.DistanceTo(target) < distance;
	}

	private bool IsFinishAnimation(string name)
	{
		return !bWMesh.AnimationPlayer.IsPlaying() && bWMesh.AnimationPlayer.CurrentAnimation.GetHashCode() != name.GetHashCode();
	}

	private bool IsFinish()
	{
		return _target.GlobalPosition.DistanceTo(GlobalPosition) < agent.PathDesiredDistance;
	}

	private void PlayAnimation()
	{
		bWMesh.AnimationPlayer.Play(_sm.ActiveStateName);
	}

	private void Rotate(Vector3 target, double delta)
	{
		var direction = target - GlobalPosition;
		direction.Y = 0;

		if (direction != Vector3.Zero)
		{
			var targetAngle = Mathf.Atan2(direction.X, direction.Z);
			var currentRotation = Rotation;

			currentRotation.Y = Mathf.LerpAngle(currentRotation.Y, targetAngle, Stats.SpeedRotation * (float)delta);
			Rotation = currentRotation;
		}
	}

	private void UseGravity(float delta)
	{
		var nextVelocity = Velocity;
		var direction = Stats.Speed * Stats.SpeedModifier * delta;
		nextVelocity.Y = -Gravity * delta;
		nextVelocity.X = Mathf.MoveToward(Velocity.X, 0f, direction);
		nextVelocity.Z = Mathf.MoveToward(Velocity.Z, 0f, direction);
		Velocity = nextVelocity;
		MoveAndSlide();
	}

	private void Move(float delta, float modifier = 1f)
	{
		if (!IsOnFloor() || agent.IsNavigationFinished())
		{
			UseGravity(delta);
			return;
		}

		var nextVelocity = Velocity;

		nextVelocity.Y = nextVelocity.Y - Gravity * delta;

		var nextPathPosition = agent.GetNextPathPosition();
		Rotate(nextPathPosition, delta);
		var direction = nextPathPosition - GlobalPosition;
		direction.Y = 0;
		direction = direction.Normalized();

		var targetVelocity = direction * (Stats.Speed * modifier);
		Velocity = targetVelocity;
		MoveAndSlide();
	}
}