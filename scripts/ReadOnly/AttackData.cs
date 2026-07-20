using Godot;

[GlobalClass]
public partial class AttackData : Resource
{
    [Export] public float Damage { get; private set; } = 10f;
    [Export] public float CoolDowm { get; private set; } = 5f;
    [Export] public float HitForce { get; private set; } = 50f;
    [Export] public float Speed { get; private set; } = 1f;
    [Export] public int UseMaxAttack { get; private set;} = 1;
    [Export] public int UseCountVFX { get; private set; } = 1;
    [Export] public PackedScene VFX { get; private set; }
}