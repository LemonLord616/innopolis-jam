using Godot;

public partial class KnockbackData(Vector3 dir, float force) : RefCounted
{
	public Vector3 dir = dir;
	public float force = force;
};