using System.Collections;
using HCoroutines;
using Godot;

public partial class Spawner : Node
{
	[Export] private SpawnerData data;
	[Export] private CharacterBody3D playerNode;
	[Export] private Marker3D spawnBWPos;
	[Export] private Route[] routes;
	public BookWalker GetBookWalker => _ref;
	public Stats GetBookWalkerStats => _ref.Stats;

	private Coroutine _spawnBW;
	private int countRespawn = 0;
	private BookWalker _ref;

	public bool IsInstanceBW()
	{
		return _ref != null;
	}

	public override void _EnterTree()
	{
		base._EnterTree();
		_spawnBW = Co.Run(SpawnBW());
	}

	public override void _ExitTree()
	{
		base._ExitTree();
		_spawnBW?.Kill();
	}

	private IEnumerator SpawnBW()
	{
		yield return Co.Wait(data.DurationFirtsSpawn);

		_ref = data.BookWalkerData.Prefab.Instantiate<BookWalker>();
		_ref.Init(new Stats.StatsConfig()
		{
			health = data.BookWalkerData.CurentHealth,
			maxHealth = data.BookWalkerData.MaxHealth,
			speed = data.BookWalkerData.Speed,
			speedModifier = data.BookWalkerData.SpeedModifier,
			speedRotation = data.BookWalkerData.SpeedRotation
		},
		new BookWalkerData.BWStorages()
		{
			attackStorage = data.BookWalkerData.AttackStorage,
			stateStorage = data.BookWalkerData.storageState
		}, routes, playerNode);
		GetTree().CurrentScene.AddChild(_ref);
		_ref.GlobalPosition = spawnBWPos.GlobalPosition;
	}
}
