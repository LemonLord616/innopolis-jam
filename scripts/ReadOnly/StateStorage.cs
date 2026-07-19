using System.IO;
using Godot;

[GlobalClass]
public partial class StateStorage : Resource
{
    [Export] private StateData[] states;

    public StateData GetStateToName(string name)
    {
        var hash = name.GetHashCode();

        foreach (var state in states)
            if (Path.GetFileNameWithoutExtension(state.ResourcePath).GetHashCode() == hash)
                return state;

        return null;
    }
}