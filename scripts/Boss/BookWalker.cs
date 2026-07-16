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

    public void Init(Stats.StatsConfig config, Route[] routes, CharacterBody3D player)
    {
        Stats.Init(config);
        this.routes = routes;
        _player = player;
        _target = _player;
        //_readRoute = Co.Run(NextPoint);
        _sm = new StateMachine();

        //states
        _sm.AddState("Idle",onEnter=> PlayeAnimation(), onLogic => ActiveGravity((float)GetPhysicsProcessDeltaTime()));
        _sm.AddState("Walk", onEnter => PlayeAnimation(), onLogic => Move((float)GetPhysicsProcessDeltaTime()));
        _sm.AddState("Run",onEnter => PlayeAnimation(), onLogic => Move((float)GetPhysicsProcessDeltaTime(), Stats.SpeedModifier));
        _sm.AddState("MeleeAttack", onEnter => PlayeAnimation());
        _sm.AddState("RangeAttack",onEnter => PlayeAnimation());
        _sm.AddState("Damage",onEnter => PlayeAnimation());
        _sm.AddState("Spell_Anger",onEnter => PlayeAnimation());
        _sm.AddState("Spell_FlyingProjectiles",onEnter => PlayeAnimation());
        _sm.AddState("Spell_HailBooks",onEnter => PlayeAnimation());
        _sm.AddState("Dead", onEnter => PlayeAnimation());

        //transitions
        _sm.AddTransitionFromAny(new Transition("","Dead", condition => !Stats.IsAlive));
        _sm.AddTransition("Idle","MeleeAttack", condition => IsReach(_player.GlobalPosition, GetDistanceBetweenTarget(areas[0].GlobalPosition)));
        _sm.AddTransition("MeleeAttack","MeleeAttack", condition => IsReach(_player.GlobalPosition, GetDistanceBetweenTarget(areas[0].GlobalPosition)) && IsFinishAnimation("MeleeAttack"));
        _sm.AddTransition("MeleeAttack","Idle", condition => !IsReach(_player.GlobalPosition, GetDistanceBetweenTarget(areas[0].GlobalPosition)) && IsFinishAnimation("MeleeAttack"));
        _sm.AddTransition("Idle","Walk", condition => _target != null && IsFinishAnimation("MelleeAttack") && !IsReach(_player.GlobalPosition,GetDistanceBetweenTarget(areas[0].GlobalPosition) * 3));
        _sm.AddTransition("Walk","Run", condition => _target != null  && IsFinishAnimation("MelleeAttack") && !IsReach(_player.GlobalPosition,GetDistanceBetweenTarget(areas[1].GlobalPosition) * 4));
        _sm.AddTransition("Walk","Idle", condition => _target == null || IsReach(_player.GlobalPosition,GetDistanceBetweenTarget(areas[0].GlobalPosition)));
        _sm.AddTransition("Run","Walk", condition => _target == null || IsReach(_player.GlobalPosition,GetDistanceBetweenTarget(areas[1].GlobalPosition) * 4));

        _sm.SetStartState("Idle");
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

    private void PlayeAnimation()
    {
        bWMesh.AnimationPlayer.Play(_sm.ActiveStateName, 0f);
    }

    private bool IsFinishAnimation(string name)
    {
        return bWMesh.AnimationPlayer.CurrentAnimation.GetHashCode() != name.GetHashCode() || !bWMesh.AnimationPlayer.IsPlaying();
    }

    private bool IsCurrentState(string name)
    {
        return _sm.ActiveStateName.GetHashCode() == name.GetHashCode();
    }
    private bool IsFinish()
    {
        return _target.GlobalPosition.DistanceTo(GlobalPosition) < agent.PathDesiredDistance;
    }

    private bool IsReach(Vector3 target, float distance)
    {
        return target.DistanceTo(GlobalPosition) < distance;
    }

    private float GetDistanceBetweenTarget(Vector3 target)
    {
        return target.DirectionTo(GlobalPosition).Length();
    }

    private IEnumerator NextPoint()
    {
        while (true)
        {
            foreach(Marker3D point in routes[0].GetPoints())
            {
                _target = point;
                agent.TargetPosition = _target.GlobalPosition;
                yield return Co.WaitUntil(IsFinish);
                _target = null;
                yield return Co.Wait(5f);
            }
        }
    }

    private void Rotate(Vector3 target, double delta)
    {
        var direction = target - GlobalPosition;
        direction.Y = 0;

        if (direction != Vector3.Zero)
        {
            var targetAngle = Mathf.Atan2(direction.X, direction.Z);
            var currentRotation = Rotation;

            currentRotation.Y = Mathf.LerpAngle(currentRotation.Y, targetAngle, Stats.Speed * (float)delta);
            Rotation = currentRotation;
        }
    }

    private void ActiveGravity(float delta)
    {
        var nextVelocity = Velocity;

        nextVelocity.Y = -Gravity;
        nextVelocity.X = Mathf.MoveToward(Velocity.X, 0.0f, Stats.Speed * Stats.SpeedModifier * delta);
        nextVelocity.Z = Mathf.MoveToward(Velocity.Z, 0.0f, Stats.Speed * Stats.SpeedModifier * delta);
        Velocity = nextVelocity;
        MoveAndSlide();
    }

    private void Move(float delta, float modifier = 1f)
    {
        if (!IsOnFloor() || agent.IsNavigationFinished())
        {
            ActiveGravity(delta);
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
        // nextVelocity.X = Mathf.MoveToward(Velocity.X, targetVelocity.X, acceleration * delta);
        // nextVelocity.Z = Mathf.MoveToward(Velocity.Z, targetVelocity.Z, acceleration * delta);
        Velocity = targetVelocity;
        MoveAndSlide();
    }
}