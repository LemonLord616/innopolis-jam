using System.Collections;
using HCoroutines;
using UnityHFSM;
using Godot;

public partial class BookWalker : CharacterBody3D
{
    [Export] private NavigationAgent3D agent;
    [Export] private BWMesh bWMesh;
    [Export] public Stats Stats {get; private set;}
    [Export] private Route[] routes;
    
    public float Gravity => (float)ProjectSettings.GetSetting("physics/3d/default_gravity");
    
    private Marker3D _target;
    private Coroutine _readRoute;

    private StateMachine _sm;

    public void Init(Stats.StatsConfig config, Route[] routes)
    {
        Stats.Init(config);
        this.routes = routes;
        _readRoute = Co.Run(NextPoint);
        _sm = new StateMachine();
        //states
        _sm.AddState("Idle",onEnter => bWMesh.AnimationPlayer.Play("Idle",0f));
        _sm.AddState("Walk", onEnter => bWMesh.AnimationPlayer.Play("Walk",0f), onLogic => Move((float)GetPhysicsProcessDeltaTime()));

        //transitions
        _sm.AddTransition("Idle","Walk", condition => _target != null);
        _sm.AddTransition("Walk","Idle", condition => _target == null);

        _sm.SetStartState("Idle");
        _sm.Init();
    }

    public override void _Process(double delta)
    {
        base._Process(delta);
        _sm.OnLogic();
    }

    public override void _ExitTree()
    {
        base._ExitTree();
        _readRoute?.Kill();
    }

    private IEnumerator NextPoint()
    {

        yield return Co.Wait(5f);
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

    private bool IsFinish()
    {
        return _target.GlobalPosition.DistanceTo(GlobalPosition) < agent.PathDesiredDistance;
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

    private void Move(float delta)
    {
        var nextVelocity = Velocity;

        nextVelocity.Y = !IsOnFloor() ? nextVelocity.Y - Gravity * delta : -0.1f;

        if (agent.IsNavigationFinished())
        {
            nextVelocity.X = Mathf.MoveToward(Velocity.X, 0.0f, Stats.Acceleration * delta);
            nextVelocity.Z = Mathf.MoveToward(Velocity.Z, 0.0f, Stats.Acceleration * delta);
            
            Velocity = nextVelocity;
            MoveAndSlide();
            return;
        }
        
        var nextPathPosition = agent.GetNextPathPosition();
        Rotate(nextPathPosition, delta);
        var direction = nextPathPosition - GlobalPosition;
        direction.Y = 0;
        direction = direction.Normalized();

        var targetVelocity = direction * Stats.Speed;
        nextVelocity.X = Mathf.MoveToward(Velocity.X, targetVelocity.X, Stats.Acceleration * delta);
        nextVelocity.Z = Mathf.MoveToward(Velocity.Z, targetVelocity.Z, Stats.Acceleration * delta);
        Velocity = nextVelocity;
        MoveAndSlide();
    }
}