using Godot;

public partial class KnockbackData(Godot.Vector3 dir, float force) : RefCounted
{
	public Vector3 dir = dir;
	public float force = force;
};

public partial class Damage : Node
{
	public void SetDamage(CharacterBody3D body, float damage, KnockbackData knockbackDataRef = null)
	{
		var sc = body.GetScript().As<Script>();

		if (sc != null && sc.GetGlobalName().ToString().GetHashCode() == "Player".GetHashCode())
		{
			body.Call("reduce", damage);
			if (knockbackDataRef != null)
				body.Call("knockback", knockbackDataRef.dir, knockbackDataRef.force);

			return;
		}else if (body is BookWalker bookWalker)
		{
			bookWalker.Stats.SetHealt(-damage);
		}
	}
}