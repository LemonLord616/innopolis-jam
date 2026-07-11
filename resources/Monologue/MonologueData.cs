using Godot;
using System;

[GlobalClass]
public partial class MonologueData : Resource
{
    [Export] public string Name { get; private set;}
    [Export] private string[] phrases;

    public string GetRandomPhrase()
    {
        return phrases[new Random().Next(0 ,phrases.Length)];
    }
}