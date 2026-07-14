using Godot;

[GlobalClass]
public partial class BookWalkerData : Resource
{
    [Export] public float CurentHealth {get; private set;} = 100f;
    [Export] public float MaxHealth { get; private set; } = 100f;
    [Export] public float Speed { get; private set;} = 10f;
    [Export] public PackedScene Prefab { get; private set;}
}