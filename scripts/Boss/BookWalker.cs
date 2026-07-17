using System.Collections;
using HCoroutines;
using UnityHFSM;
using Godot;

public partial class BookWalker : CharacterBody3D
{
    [Export] private NavigationAgent3D agent;
    [Export] private BWMesh bWMesh;
    [Export] public Stats Stats {get; private set;}
    [Export] private Area3D[] areas; // 0 - melle, 1 - range
    [Export] private Route[] routes;
    
    public float Gravity => (float)ProjectSettings.GetSetting("physics/3d/default_gravity");
    
    private CharacterBody3D _player;
    private Node3D _target;
    private Coroutine _readRoute;

    private StateMachine _sm;
    private Damage _damage;

    public void Init(Stats.StatsConfig config, Route[] routes, CharacterBody3D player, Damage damage)
    {
        Stats.Init(config);
        this.routes = routes;
        _player = player;
        _target = _player;
        _damage = damage;
        bWMesh.OnHitEv += () => _damage.SetDamage(_player, 10f);
        _sm = new StateMachine();

        //states
        _sm.AddState(nameof(AnimationKeys.Idle), onEnter=> PlayAnimation(), onLogic =>
        {
            var fdelta = (float)GetPhysicsProcessDeltaTime();
            if (_player != null)
                Rotate(_player.GlobalPosition,fdelta);
            UseGravity(fdelta);
        });
        _sm.AddState(nameof(AnimationKeys.Walk), onEnter => PlayAnimation(), onLogic => Move((float)GetPhysicsProcessDeltaTime()));
        _sm.AddState(nameof(AnimationKeys.Run), onEnter => PlayAnimation(), onLogic => Move((float)GetPhysicsProcessDeltaTime(), Stats.SpeedModifier));
        _sm.AddState(nameof(AnimationKeys.MeleeAttack), onEnter => PlayAnimation());
        _sm.AddState(nameof(AnimationKeys.RangeAttack), onEnter => PlayAnimation());
        _sm.AddState(nameof(AnimationKeys.Damage), onEnter => PlayAnimation());
        _sm.AddState(nameof(AnimationKeys.Spell_Anger), onEnter => PlayAnimation());
        _sm.AddState(nameof(AnimationKeys.Spell_FlyingProjectiles), onEnter => PlayAnimation());
        _sm.AddState(nameof(AnimationKeys.Spell_HailBooks), onEnter => PlayAnimation());
        _sm.AddState(nameof(AnimationKeys.Dead), onEnter => PlayAnimation());

        //transitions
        _sm.AddTransitionFromAny(new Transition(null, nameof(AnimationKeys.Dead), condition => !Stats.IsAlive));
        _sm.AddTransition(nameof(AnimationKeys.Idle), nameof(AnimationKeys.MeleeAttack), condition => IsWithinDistance(_target.GlobalPosition,areas[0].Scale.Z));
        _sm.AddTransition(nameof(AnimationKeys.Idle), nameof(AnimationKeys.Walk), condition => !IsWithinDistance(_target.GlobalPosition,areas[0].Scale.Z));
        _sm.AddTransition(nameof(AnimationKeys.Walk), nameof(AnimationKeys.Run), condition => !IsWithinDistance(_target.GlobalPosition,areas[1].Scale.Z));
        _sm.AddTransition(nameof(AnimationKeys.Walk), nameof(AnimationKeys.Idle), condition => IsWithinDistance(_target.GlobalPosition,areas[0].Scale.Z));
        _sm.AddTransition(nameof(AnimationKeys.Run), nameof(AnimationKeys.Walk), condition => IsWithinDistance(_target.GlobalPosition,areas[1].Scale.Z));
        _sm.AddTransition(nameof(AnimationKeys.MeleeAttack), nameof(AnimationKeys.MeleeAttack), condition => IsFinishAnimation(nameof(AnimationKeys.MeleeAttack)) && IsWithinDistance(_target.GlobalPosition,areas[0].Scale.Z));
        _sm.AddTransition(nameof(AnimationKeys.MeleeAttack), nameof(AnimationKeys.Idle), condition => IsFinishAnimation(nameof(AnimationKeys.MeleeAttack)) && !IsWithinDistance(_target.GlobalPosition,areas[0].Scale.Z));
        
        _sm.SetStartState(nameof(AnimationKeys.Idle));
        _sm.Init();
    }

    public override void _Process(double delta)
    {
        base._Process(delta);
        GD.Print(_sm.ActiveStateName);
        _sm.OnLogic();
        if (ReferenceEquals(_target, _player))
                agent.TargetPosition = _target.GlobalPosition;
    }

	public override void _ExitTree()
	{
		base._ExitTree();
		_readRoute?.Kill();
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
        bWMesh.AnimationPlayer.Play(_sm.ActiveStateName, 0f);
    }

    private void Rotate(Vector3 target, double delta)
    {
        var direction = target - GlobalPosition;
        direction.Y = 0;
s

		if (direction != Vector3.Zero)
		{
			var targetAngle = Mathf.Atan2(direction.X, direction.Z);
			var currentRotation = Rotation;

			currentRotation.Y = Mathf.LerpAngle(currentRotation.Y, targetAngle, Stats.Speed * (float)delta);
			Rotation = currentRotation;
		}
	}

    private void UseGravity(float delta)
    {
        var nextVelocity = Velocity;
        var direction = Stats.Speed * Stats.SpeedModifier * delta;
        nextVelocity.Y = -Gravity;
        nextVelocity.X = Mathf.MoveToward(Velocity.X, 0.0f, direction);
        nextVelocity.Z = Mathf.MoveToward(Velocity.Z, 0.0f, direction);
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
