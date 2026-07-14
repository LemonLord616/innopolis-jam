using Godot;
using System;

[GlobalClass]
public partial class MonoSelectorData : Resource
{
    [Export] public float VisibleDuration { get; private set;} = 2f;
    [Export] public float InVisibleDuration { get; private set;} = 5f;
    [Export] private MonologueData[] monologues;

    public MonologueData GetRandomMonologue()
    {
        return monologues[new Random().Next(0, monologues.Length)];
    }
}