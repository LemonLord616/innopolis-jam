using Godot;

[GlobalClass]
public partial class StateData : Resource
{
    [Export] public float Duration { get; private set; }
    [Export] public float SpeedAnimation { get; private set; }
}