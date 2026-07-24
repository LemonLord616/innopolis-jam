using System.IO;
using Godot;

[GlobalClass]
public partial class BossProgress : Resource
{
    [Export] private Level[] levels;

    public bool HasOpened(int level, string name)
    {
        var hash = name.GetHashCode();
        foreach (var res in levels[level].opened)
        {
            if (Path.GetFileNameWithoutExtension(res.ResourcePath).GetHashCode() == hash)
                return true;
        }

        return false;
    }
}