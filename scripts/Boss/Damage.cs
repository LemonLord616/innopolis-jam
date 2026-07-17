using Godot;

public partial class Damage : Node
{
    public void SetDamage(CharacterBody3D body, float damage, float force = 0f)
    {
        var sc = body.GetScript().As<Script>();

        if (sc != null && sc.GetGlobalName().ToString().GetHashCode() == "Player".GetHashCode())
        {
            GD.Print($"damage {damage}");
            body.Set("hp",((float)body.Get("hp")) - damage);
            return;
        }else if (body is BookWalker bookWalker)
        {
            bookWalker.Stats.SetHealt(-damage);
        }
    }
}