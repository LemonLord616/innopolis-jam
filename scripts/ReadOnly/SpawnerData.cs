using Godot;

[GlobalClass]
public partial class SpawnerData : Resource
{
    [Export] public BookWalkerData BookWalkerData { get; private set;}
    [Export] public float DurationFirtsSpawn { get; private set;} = 10f;
    [Export] public int CountRespawnInDead { get; private set;} = 10;
    [Export] public float DurationbetweenRespawned {get; private set;} = 5f;
    [Export] public float ProcentToUp { get; private set;} = 10f;
}