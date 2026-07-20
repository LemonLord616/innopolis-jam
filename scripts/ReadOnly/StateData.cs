using Godot;

[GlobalClass]
public partial class StateData : Resource
{
    [Export] public float Duration { get; private set; } = 1f;
    [Export] public float SpeedAnimation { get; private set; } = 1f;
}