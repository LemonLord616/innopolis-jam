using System.Collections;
using HCoroutines;
using UnityHFSM;
using Godot;

[GlobalClass]
public partial class BookWalker : CharacterBody3D
{
	[Export] private NavigationAgent3D agent;
	[Export] private BWMesh bWMesh;
	[Export] public Stats Stats { get; private set; }
	[Export] private Area3D[] areas; // 0 - melle, 1 - range
	[Export] private MeshInstance3D[] paths; // 0 - melee, 1 - meleeAoe
	[Export] private ShapeCast3D detect;
	[Export] private Route[] routes;

	public float Gravity => (float)ProjectSettings.GetSetting("physics/3d/default_gravity");

	private CharacterBody3D _player;
	private Node3D _target;
	private Coroutine _readRoute;

	private StateMachine _sm;
	private CoolDown _coolDown;
	private KnockbackData _knockbackData;
	private const float DOT = .7f;//45 Degrees
	private bool _attackFlag;

	public void Init(Stats.StatsConfig config, BookWalkerData.BWStorages storages, Route[] routes, CharacterBody3D player)
	{
		Stats.Init(config);
		this.routes = routes;
		_player = player;
		_target = _player;
		_coolDown = new();
		Stats.OnDamageEv += () => _sm.Trigger(nameof(AnimationKeys.Damage));
		bWMesh.OnHitEv += () =>
		{
			var melee = storages.attackStorage.GetAttackToName(nameof(AnimationKeys.MeleeAttack));
			Damage.SetDamage(_player, melee.Damage, new KnockbackData(GlobalTransform.Basis.Z, melee.HitForce));
		};

		_sm = new();

		//states
		_sm.AddState(nameof(AnimationKeys.Idle),
		onEnter =>
		{
			_attackFlag = false;
			PlayAnimation();
			foreach (var path in paths)
				path.Visible = false;
		},
		onLogic =>
	   {
		   var fdelta = (float)GetPhysicsProcessDeltaTime();
		   if (_player != null)
			   Rotate(_player.GlobalPosition, fdelta);
		   UseGravity(fdelta);
	   });
		_sm.AddState(nameof(AnimationKeys.Walk), onEnter => PlayAnimation(), onLogic => Move((float)GetPhysicsProcessDeltaTime(), storages.stateStorage.GetStateToName(nameof(AnimationKeys.Walk)).SpeedAnimation));
		_sm.AddState(nameof(AnimationKeys.Run), onEnter => PlayAnimation(), onLogic => Move((float)GetPhysicsProcessDeltaTime(), Stats.SpeedModifier));
		_sm.AddState(nameof(AnimationKeys.Damage),
		onEnter =>
		{
			PlayAnimation();
			var atack = storages.attackStorage.GetAttackToName(nameof(AnimationKeys.Damage));
			_coolDown.Start(nameof(AnimationKeys.Damage), atack.UseMaxAttack, atack.CoolDowm);
		});
		_sm.AddState(nameof(AnimationKeys.Dead),
		onEnter =>
		 {
			 _target = null;
			 PlayAnimation();
			 foreach (var path in paths)
				 path.Visible = false;
		 });
		_sm.AddState(nameof(StateKeys.Dash),
	   onEnter =>
	   {
		   var dash = storages.attackStorage.GetAttackToName(nameof(StateKeys.Dash));
		   _coolDown.Start(nameof(StateKeys.Dash), dash.UseMaxAttack, dash.CoolDowm);
	   },
	   onLogic => Move((float)GetPhysicsProcessDeltaTime(), Stats.SpeedModifier * storages.stateStorage.GetStateToName(nameof(StateKeys.TurnDash)).SpeedAnimation),
	   onExit =>
	   {
		   _target = _player;
	   });
		_sm.AddState(nameof(StateKeys.TurnDash),
		onEnter =>
		{
			var projectile = detect.GetCollider(0);
			var toProjectile = ((projectile as Node3D).GlobalPosition - GlobalPosition).Normalized();
			_target = null;
			var myRight = GlobalTransform.Basis.X.Normalized();
			var myBackward = GlobalTransform.Basis.Z.Normalized();
			var fleeDirection = Vector3.Zero;
			var distanceMultiplier = 2f;
			var timeCodeAnimation = .4f;

			fleeDirection += myRight.Dot(toProjectile) > 0f ? -myRight : myRight;
			fleeDirection += myBackward.Dot(toProjectile) > 0f ? -myBackward : myBackward;
			fleeDirection = fleeDirection.Normalized();

			agent.TargetPosition = GlobalPosition + (fleeDirection * distanceMultiplier);
			if (myBackward.Dot(toProjectile) > 0f)
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
			var attack = storages.attackStorage.GetAttackToName(nameof(StateKeys.TurnDash));
			_coolDown.Start(nameof(StateKeys.TurnDash), attack.UseMaxAttack, attack.CoolDowm);
		},
		onLogic => Move((float)GetPhysicsProcessDeltaTime(), Stats.SpeedModifier * storages.stateStorage.GetStateToName(nameof(StateKeys.TurnDash)).SpeedAnimation),
		onExit =>
		{
			_target = _player;
		});
		_sm.AddState(nameof(StateKeys.Knockback),
		onEnter =>
		{
			_target = null;
			agent.TargetPosition = GlobalPosition + (-_knockbackData.dir * (_knockbackData.force / 10f));
		},
		onLogic => Move((float)GetPhysicsProcessDeltaTime(), Stats.SpeedModifier * storages.stateStorage.GetStateToName(nameof(StateKeys.Knockback)).SpeedAnimation),
		onExit =>
		{
			_knockbackData = null;
			_target = _player;
		});

		//combat state
		_sm.AddState(nameof(StateKeys.PreMeleeAttack), onEnter =>
		{
			_attackFlag = true;
			bWMesh.AnimationPlayer.Play(nameof(AnimationKeys.MeleeAttack));
			bWMesh.AnimationPlayer.Seek(0f, true);
			bWMesh.AnimationPlayer.Pause();
			paths[0].Visible = true;
			var attack = storages.attackStorage.GetAttackToName(nameof(AnimationKeys.MeleeAttack));
			_coolDown.Start(nameof(AnimationKeys.MeleeAttack), attack.UseMaxAttack, attack.CoolDowm);
		});
		_sm.AddState(nameof(AnimationKeys.MeleeAttack),
		onEnter =>
		{
			var state = storages.stateStorage.GetStateToName(nameof(AnimationKeys.MeleeAttack));
			bWMesh.AnimationPlayer.Play(_sm.ActiveStateName, customSpeed: state.SpeedAnimation);
		},
		onExit => paths[0].Visible = false);
		_sm.AddState(nameof(StateKeys.PreMeleeAttackAOE), onEnter =>
		{
			_attackFlag = true;
			bWMesh.AnimationPlayer.Play(nameof(AnimationKeys.MeleeAttackAOE));
			bWMesh.AnimationPlayer.Seek(0f, true);
			bWMesh.AnimationPlayer.Pause();
			paths[1].Visible = true;
			var attack = storages.attackStorage.GetAttackToName(nameof(AnimationKeys.MeleeAttackAOE));
			_coolDown.Start(nameof(AnimationKeys.MeleeAttackAOE), attack.UseMaxAttack, attack.CoolDowm);
		});
		_sm.AddState(nameof(AnimationKeys.MeleeAttackAOE),
		onEnter =>
		{
			var state = storages.stateStorage.GetStateToName(nameof(AnimationKeys.MeleeAttackAOE));
			bWMesh.AnimationPlayer.Play(_sm.ActiveStateName, customSpeed: state.SpeedAnimation);
		},
		onLogic =>
		{
			Move((float)GetPhysicsProcessDeltaTime(), storages.attackStorage.GetAttackToName(nameof(AnimationKeys.MeleeAttackAOE)).Speed);
			foreach (var body in areas[0].GetOverlappingBodies())
			{
				if (ReferenceEquals(body, _player))
				{
					var attack = storages.attackStorage.GetAttackToName(nameof(AnimationKeys.MeleeAttackAOE));
					Damage.SetDamage(_player, attack.Damage, new(GlobalTransform.Basis.Z, attack.HitForce));
				}
			}
		},
		onExit => paths[1].Visible = false);
		_sm.AddState(nameof(AnimationKeys.RangeAttack),
		onEnter =>
		{
			_attackFlag = true;
			var attack = storages.attackStorage.GetAttackToName(nameof(AnimationKeys.RangeAttack));
			for (var i = 0; i < attack.UseCountVFX; i++)
			{
				var book = attack.VFX.Instantiate<Book>();
				var scale = book.Scale;
				var up = GlobalPosition + GlobalTransform.Basis.Y.Normalized() * (areas[0].Scale.Y / 2);
				var down = GlobalPosition + -GlobalTransform.Basis.Y.Normalized() * (areas[0].Scale.Y / 2);
				var spawnPos = GetRandomPositionOnCircle(down, areas[0].Scale.X);
				GetTree().CurrentScene.AddChild(book);
				book.GlobalPosition = spawnPos;
				book.Init(attack, _player, up);
				book.Scale = scale;
			}
			PlayAnimation();
			_coolDown.Start(nameof(AnimationKeys.RangeAttack), attack.UseMaxAttack, attack.CoolDowm);
		});
		_sm.AddState(nameof(AnimationKeys.Spell_Anger), onEnter => PlayAnimation());
		_sm.AddState(nameof(AnimationKeys.Spell_HailBooks), onEnter => PlayAnimation());

		//transitions
		_sm.AddTransitionFromAny(new Transition(null, nameof(AnimationKeys.Dead), condition => !Stats.IsAlive));
		_sm.AddTransition(nameof(AnimationKeys.Idle), nameof(AnimationKeys.Walk), condition => !PlayerInArea(areas[0]));
		_sm.AddTransition(nameof(AnimationKeys.Walk), nameof(AnimationKeys.Run), condition => !PlayerInArea(areas[1]));
		_sm.AddTransition(nameof(AnimationKeys.Walk), nameof(AnimationKeys.Idle), condition => PlayerInArea(areas[0]));
		_sm.AddTransition(nameof(AnimationKeys.Walk), nameof(StateKeys.Dash), condition => !_attackFlag && PlayerInArea(areas[1]) && !_coolDown.IsCoolDown(nameof(StateKeys.Dash), storages.attackStorage.GetAttackToName(nameof(StateKeys.Dash)).UseMaxAttack));
		_sm.AddTransition(nameof(AnimationKeys.Run), nameof(AnimationKeys.Walk), condition => PlayerInArea(areas[1]));
		_sm.AddTransition(new TransitionAfter(nameof(StateKeys.TurnDash), nameof(AnimationKeys.Idle), storages.stateStorage.GetStateToName(nameof(StateKeys.TurnDash)).Duration));
		_sm.AddTransitionFromAny(new Transition(null, nameof(StateKeys.TurnDash), condition => _target != null && !_attackFlag && detect.GetCollisionCount() > 0 &&
		!_coolDown.IsCoolDown(nameof(StateKeys.Dash), storages.attackStorage.GetAttackToName(nameof(StateKeys.TurnDash)).UseMaxAttack)));

		_sm.AddTriggerTransitionFromAny(nameof(AnimationKeys.Damage), new Transition(null, nameof(AnimationKeys.Damage), condition => !_coolDown.IsCoolDown(nameof(AnimationKeys.Damage), storages.attackStorage.GetAttackToName(nameof(AnimationKeys.Damage)).UseMaxAttack) && Stats.IsAlive));
		_sm.AddTransition(new TransitionAfter(nameof(AnimationKeys.Damage), nameof(AnimationKeys.Idle), (float)bWMesh.AnimationPlayer.GetAnimation(nameof(AnimationKeys.Damage)).Length));
		_sm.AddTriggerTransitionFromAny(nameof(StateKeys.Knockback), new Transition(nameof(AnimationKeys.Damage), nameof(StateKeys.Knockback), condition => Stats.IsAlive));
		_sm.AddTransition(new Transition(nameof(StateKeys.Knockback), nameof(AnimationKeys.Idle), condition => agent.IsNavigationFinished()));

		//Combat
		_sm.AddTransitionFromAny(new Transition(null, nameof(StateKeys.PreMeleeAttack), condition => _target != null && !_attackFlag && !_coolDown.IsCoolDown(nameof(AnimationKeys.MeleeAttack), storages.attackStorage.GetAttackToName(nameof(AnimationKeys.MeleeAttack)).UseMaxAttack) &&
		 PlayerInArea(areas[0]) && IsForwardTarget(_target.GlobalPosition)));
		_sm.AddTransition(new TransitionAfter(nameof(StateKeys.PreMeleeAttack), nameof(AnimationKeys.MeleeAttack), delay: storages.stateStorage.GetStateToName(nameof(StateKeys.PreMeleeAttack)).Duration));
		_sm.AddTransition(nameof(AnimationKeys.MeleeAttack), nameof(AnimationKeys.Idle), condition => IsFinishAnimation(nameof(AnimationKeys.MeleeAttack)));

		_sm.AddTransition(nameof(AnimationKeys.Idle), nameof(AnimationKeys.MeleeAttackAOE), condition => PlayerInArea(areas[0]));
		_sm.AddTransitionFromAny(new Transition(null, nameof(StateKeys.PreMeleeAttackAOE), condition => _target != null && !_attackFlag && !_coolDown.IsCoolDown(nameof(AnimationKeys.MeleeAttackAOE), storages.attackStorage.GetAttackToName(nameof(AnimationKeys.MeleeAttackAOE)).UseMaxAttack) && PlayerInArea(areas[0])));
		_sm.AddTransition(new TransitionAfter(nameof(StateKeys.PreMeleeAttackAOE), nameof(AnimationKeys.MeleeAttackAOE), storages.stateStorage.GetStateToName(nameof(StateKeys.PreMeleeAttackAOE)).Duration));
		_sm.AddTransition(new TransitionAfter(nameof(AnimationKeys.MeleeAttackAOE), nameof(AnimationKeys.Idle), delay: storages.stateStorage.GetStateToName(nameof(AnimationKeys.MeleeAttackAOE)).Duration));

		_sm.AddTransitionFromAny(new Transition(null, nameof(AnimationKeys.RangeAttack), condition => _target != null && !_attackFlag && !_coolDown.IsCoolDown(nameof(AnimationKeys.RangeAttack), storages.attackStorage.GetAttackToName(nameof(AnimationKeys.RangeAttack)).UseMaxAttack) && PlayerInArea(areas[1])));
		_sm.AddTransition(nameof(AnimationKeys.RangeAttack), nameof(AnimationKeys.Idle), condition => IsFinishAnimation(nameof(AnimationKeys.RangeAttack)));

		_sm.SetStartState(nameof(AnimationKeys.Idle));
		_sm.Init();
	}

	public override void _Process(double delta)
	{
		base._Process(delta);
		GD.PrintRich($"[color=green]state = {_sm.ActiveStateName} [/color]");
		_sm.OnLogic();
		detect.ForceShapecastUpdate();
		if (ReferenceEquals(_target, _player) && _target.GlobalPosition != agent.TargetPosition)
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

	private bool PlayerInArea(Area3D area)
	{
		return area.HasOverlappingBodies();
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

	public Vector3 GetRandomPositionOnCircle(Vector3 center, float radius)
	{
		var rng = new RandomNumberGenerator();
		rng.Randomize();

		var randomAngle = rng.RandfRange(0.0f, Mathf.Tau); // Mathf.Tau — это 2 * Pi

		var offsetX = Mathf.Cos(randomAngle) * radius;
		var offsetZ = Mathf.Sin(randomAngle) * radius;

		return new Vector3(center.X + offsetX, center.Y, center.Z + offsetZ);
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
		nextVelocity.Y += -Gravity * delta;
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
