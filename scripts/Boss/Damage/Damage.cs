using Godot;

[GlobalClass]
public partial class Damage : Node
{
	static public void SetDamage(CharacterBody3D body, float damage, KnockbackData knockbackDataRef = null)
	{
		var sc = body.GetScript().As<Script>();

		if (sc != null && sc.GetGlobalName().ToString().GetHashCode() == "Player".GetHashCode())
		{
			body.Call("reduce", damage);
			if (knockbackDataRef != null)
				body.Call("knockback", knockbackDataRef.dir, knockbackDataRef.force);

			return;
		}
		else if (body is BookWalker bookWalker)
		{
			bookWalker.Stats.SetHealt(-damage);
			if (knockbackDataRef != null)
				bookWalker.Knockback(knockbackDataRef);
		}
	}
}
