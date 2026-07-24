using System.Collections;
using HCoroutines;
using System.IO;
using Godot;

public partial class SpellBerserk : Node
{
    [Export] private SpellPacifier self;
    [Export] private BookWalker bookWalker;
    [Export] private float procentActivation;
    [Export] private float procentBaff;
    [Export] private float TimeLife;

    private float condition;
    private bool _isUsed = false;

    public override void _Ready()
    {
        base._Ready();
        bookWalker.OnInitEv += Init;
    }

    public override void _ExitTree()
    {
        base._ExitTree();
        bookWalker.Stats.OnDamageEv -= OnDamage;
    }

    private void Init()
    {
        bookWalker.OnInitEv -= Init;
        if (bookWalker.BossProgress.HasOpened(bookWalker.CountRespawn, Path.GetFileNameWithoutExtension(self.ResourcePath)))
        {
            bookWalker.Stats.OnDamageEv += OnDamage;
            condition = bookWalker.Stats.MaxHealth / 100f * procentActivation;
        }        
    }


    private void OnDamage()
    {
        if (bookWalker.Stats.IsAlive && bookWalker.Stats.CurentHealth <= condition && !_isUsed)
            Co.Run(Delay);
    }

    private IEnumerator Delay()
    {
        _isUsed = true;
        var healthBuff = bookWalker.Stats.MaxHealth / 100f * procentBaff;
        var speedBuff = bookWalker.Stats.Speed / 100f * procentBaff;
        bookWalker.Stats.SetHealt(healthBuff);
        bookWalker.Stats.SetSpeed(speedBuff);
        yield return Co.Wait(TimeLife);
        bookWalker.Stats.SetHealt(-healthBuff);
        bookWalker.Stats.SetSpeed(-speedBuff);
    }
}