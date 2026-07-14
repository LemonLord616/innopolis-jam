using System.Collections;
using HCoroutines;
using Godot;

public partial class BookWalker : CharacterBody3D
{
    [Export] private NavigationAgent3D agent;
    [Export] public float Acceleration { get; set; } = 15.0f;
    [Export] public Stats Stats {get; private set;}
    [Export] private Route[] routes;
    
    public float Gravity => (float)ProjectSettings.GetSetting("physics/3d/default_gravity");
    
    private Marker3D _target;
    private Coroutine _readRoute;

    public void Init(Stats.StatsConfig config, Route[] routes)
    {
        Stats.Init(config);
        this.routes = routes;
        _readRoute = Co.Run(NextPoint);
    }

    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);
        if (_readRoute == null) return;
        Rotate(_target, delta);
        Move(delta);
    }

    public override void _ExitTree()
    {
        base._ExitTree();
        _readRoute?.Kill();
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
            }
        }
    }

    private bool IsFinish()
    {
        return _target.GlobalPosition.DistanceTo(GlobalPosition) < agent.PathDesiredDistance;
    }

    private void Rotate(Marker3D target, double delta)
    {
        var direction = target.GlobalPosition - GlobalPosition;
        direction.Y = 0;

        if (direction != Vector3.Zero)
        {
            var targetAngle = Mathf.Atan2(direction.X, direction.Z);
            var currentRotation = Rotation;

            currentRotation.Y = Mathf.LerpAngle(currentRotation.Y, targetAngle, Stats.Speed * (float)delta);
            Rotation = currentRotation;
        }
    }

    private void Move(double delta)
    {
        var nextVelocity = Velocity;

        nextVelocity.Y = !IsOnFloor() ? nextVelocity.Y - Gravity * (float)delta : -0.1f;

        if (agent.IsNavigationFinished())
        {
            nextVelocity.X = Mathf.MoveToward(Velocity.X, 0.0f, Acceleration * (float)delta);
            nextVelocity.Z = Mathf.MoveToward(Velocity.Z, 0.0f, Acceleration * (float)delta);
            
            Velocity = nextVelocity;
            MoveAndSlide();
            return;
        }

        var direction = _target.GlobalPosition - GlobalPosition;
        direction.Y = 0;
        direction = direction.Normalized();

        var targetVelocity = direction * Stats.Speed;
        nextVelocity.X = Mathf.MoveToward(Velocity.X, targetVelocity.X, Acceleration * (float)delta);
        nextVelocity.Z = Mathf.MoveToward(Velocity.Z, targetVelocity.Z, Acceleration * (float)delta);
        Velocity = nextVelocity;
        MoveAndSlide();
    }
}