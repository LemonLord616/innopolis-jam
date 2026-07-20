using System.Collections.Generic;
using System.Collections;
using HCoroutines;

public partial class CoolDown
{
    private Dictionary<string, int> _states;

    public CoolDown()
    {
        _states = new();
    }

    public bool IsCoolDown(string stateName, int useMaxCount)
    {
        if (!_states.TryGetValue(stateName, out var count))
            return false;

            return count >= useMaxCount;
    }

    public void Start(string stateName, int useMaxCount, float delay)
    {
        if (IsCoolDown(stateName, useMaxCount)) return;

        Co.Run(Delay(stateName, delay));
    }

    private IEnumerator Delay(string stateName, float delay)
    {
        _states[stateName] = _states.ContainsKey(stateName) ? _states[stateName] + 1 : 1;
        yield return Co.Wait(delay);
        _states[stateName]--;

        if (_states[stateName] == 0)
        _states.Remove(stateName);
    }
}