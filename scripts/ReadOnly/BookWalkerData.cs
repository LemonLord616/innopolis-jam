using Godot;

[GlobalClass]
public partial class BookWalkerData : Resource
{
    public struct BWStorages
    {
        public StateStorage stateStorage;
        public AttackStorage attackStorage;
    }

    [Export] public float CurentHealth {get; private set;} = 100f;
    [Export] public float MaxHealth { get; private set; } = 100f;
    [Export] public float Speed { get; private set;} = 5f;
    [Export] public float SpeedModifier { get; set; } = 1f;
    [Export] public float SpeedRotation { get; private set;} = 2f;
    [Export] public PackedScene Prefab { get; private set;}
    [Export] public StateStorage storageState {get; private set;}
    [Export] public AttackStorage AttackStorage { get; private set;}
}