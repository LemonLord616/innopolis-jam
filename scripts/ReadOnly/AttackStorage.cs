using System.IO;
using Godot;

[GlobalClass]
public partial class AttackStorage : Resource
{
    [Export] private AttackData[] attacks;

    public AttackData GetAttackToName(string name)
    {
        var hash = name.GetHashCode();

        foreach (var attack in attacks)
            if (Path.GetFileNameWithoutExtension(attack.ResourcePath).GetHashCode() == hash)
                return attack;

        return null;
    }
}