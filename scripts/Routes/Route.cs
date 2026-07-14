using System.Collections;
using Godot;

public partial class Route : Node
{
    [Export] private Marker3D[] points;

    public IEnumerable GetPoints()
    {
        return points;
    }
}