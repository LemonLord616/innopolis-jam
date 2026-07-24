using System.Collections.Generic;
using System.Collections;
using HCoroutines;
using System.IO;
using Godot;

public partial class SpellHailBooks : Node
{
    [Export] private BookWalker bookWalker;
    [Export] private SpellPacifier self;
    [Export] private PackedScene prefabArea;
    [Export] private Vector2 randCoolDown;
    [Export] private float lifeTime;
    [Export] private float preAttackDuration;
    [Export] private PackedScene prefabBook;
    [Export] private int countBook;

    private HailBooksArea _area;
    private List<HailBook> _books;

    public override void _Ready()
    {
        base._Ready();
        bookWalker.OnInitEv += Init;
    }

    private void Init()
    {
        bookWalker.OnInitEv -= Init;
        _books = new(countBook);
        if (bookWalker.BossProgress.HasOpened(bookWalker.CountRespawn, Path.GetFileNameWithoutExtension(self.ResourcePath)))
            Co.Run(Delay);
    }

    private IEnumerator Delay()
    {
        while (bookWalker.Stats.IsAlive)
        {
            _area?.QueueFree();
            yield return Co.Wait((float)GD.RandRange(randCoolDown.X, randCoolDown.Y));
            _area = prefabArea.Instantiate<HailBooksArea>();
            var scale = _area.Scale;
            _area.GlobalPosition = bookWalker.Player.GlobalPosition - bookWalker.Player.GlobalTransform.Basis.Y;
            GetTree().CurrentScene.AddChild(_area);
            _area.Scale = scale;
            yield return null;
            for (int i = 0; i < countBook; i++)
            {
                var book = prefabBook.Instantiate<HailBook>();
                scale = book.Scale;
                var pos = _area.UpPoint.GlobalPosition;
                pos.X = _area.GlobalPosition.X;
                pos.Z = _area.GlobalPosition.Z;
                book.GlobalPosition = GetRandomPointInCircle(pos, _area.Scale.Z / 2f);
                GetTree().CurrentScene.AddChild(book);
                book.Scale = scale;
                book.Init(bookWalker.Player);
                _books.Add(book);
                yield return Co.Wait(preAttackDuration / countBook);
            }

            yield return Co.Wait(lifeTime);
            for (var i = _books.Count - 1; i >= 0; i--)
            {
                var book = _books[i];
                _books.Remove(book);
                book.QueueFree();
            }
            _books.Clear();
        }
    }

    public Vector3 GetRandomPointInCircle(Vector3 center, float radius)
    {
        var rng = new RandomNumberGenerator();
        rng.Randomize();

        var angle = rng.RandfRange(0f, Mathf.Tau); // Tau = 2 * PI
        var r = radius * Mathf.Sqrt(rng.Randf());

        var x = center.X + r * Mathf.Cos(angle);
        var z = center.Z + r * Mathf.Sin(angle);

        return new Vector3(x, center.Y, z);
    }

}