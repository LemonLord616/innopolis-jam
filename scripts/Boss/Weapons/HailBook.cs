using Godot;

public partial class HailBook : Area3D
{
    [Export] private float speed;
    [Export] private float damage;
    [Export] private float hitForce;
    [Export] private float PointYDown;

    private CharacterBody3D _player;
    private Vector3 _startPos;
    private bool _isInit = false;

    public void Init(CharacterBody3D player)
    {
        _player = player;
        _startPos = GlobalPosition;
        BodyEntered += OnCollisionEntered;
        _isInit = true;
    }

	public override void _ExitTree()
	{
		base._ExitTree();
        BodyEntered -= OnCollisionEntered;
	}


    private void OnCollisionEntered(Node3D body)
    {
        if (ReferenceEquals(body, _player))
            Damage.SetDamage(_player, damage, new KnockbackData(GlobalTransform.Basis.Z, hitForce));
    }

    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);
        if (!_isInit) return;
        GlobalPosition += Vector3.Down * speed * (float)delta;

        if (GlobalPosition.Y < PointYDown)
            GlobalPosition = _startPos;
    }
}