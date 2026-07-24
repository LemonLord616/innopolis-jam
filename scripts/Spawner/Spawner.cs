using System.Collections;
using HCoroutines;
using Godot;

public partial class Spawner : Node
{
	[Export] private SpawnerData data;
	[Export] private CharacterBody3D playerNode;
	[Export] private Marker3D spawnBWPos;
	public BookWalker GetBookWalker => _ref;
	public Stats GetBookWalkerStats => _ref.Stats;
	public int CountRespawn { get; private set; } = 0;

	private Coroutine _spawnBW;
	private BookWalker _ref;
	private bool _spawn = true;

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

	private void BossDead()
	{
		_ref.Stats.OnDeadEv -= BossDead;
		if (_ref != null)
			_ref.QueueFree();
		_ref = null;
		_spawn = true;
	}

	private IEnumerator SpawnBW()
	{
		while (CountRespawn < data.CountRespawnInDead)
		{
			yield return Co.WaitUntil(() => _spawn);
			yield return Co.Wait(CountRespawn < 1 ? data.DurationFirtsSpawn : data.DurationbetweenRespawned);

			_ref = data.BookWalkerData.Prefab.Instantiate<BookWalker>();
			_ref.GlobalPosition = spawnBWPos.GlobalPosition;
			GetTree().CurrentScene.AddChild(_ref);
			_ref.Init(new Stats.StatsConfig()
			{
				health = data.BookWalkerData.CurentHealth + UpStatToRespawn(data.BookWalkerData.CurentHealth),
				maxHealth = data.BookWalkerData.MaxHealth + UpStatToRespawn(data.BookWalkerData.MaxHealth),
				speed = data.BookWalkerData.Speed + UpStatToRespawn(data.BookWalkerData.Speed),
				speedModifier = data.BookWalkerData.SpeedModifier + UpStatToRespawn(data.BookWalkerData.SpeedModifier),
				speedRotation = data.BookWalkerData.SpeedRotation + UpStatToRespawn(data.BookWalkerData.SpeedRotation)
			},
			new BookWalkerData.BWStorages()
			{
				attackStorage = data.BookWalkerData.AttackStorage,
				stateStorage = data.BookWalkerData.storageState
			}, playerNode, CountRespawn);
			CountRespawn++;
			_ref.Stats.OnDeadEv += BossDead;
			_spawn = false;
		}
	}

	private float UpStatToRespawn(float stat)
	{
		return (stat / 100f) * data.ProcentToUp * CountRespawn;
	}
}
