a={u'or': [{u'and': [{u'evaluation_periods': 3, u'metrics': [u'f29f95fd-c3f6-4404-a49a-c14c3e92baf5'], u'aggregation_method': u'mean', u'granularity': 60, u'threshold': 1000000.0, u'type': u'gnocchi_aggregation_by_metrics_threshold', u'comparison_operator': u'lt'}, {u'aggregation_method': u'mean', u'resource_type': u'instance', u'evaluation_periods': 3, u'threshold': 1000000.0, u'metric': u'memory.usage', u'resource_id': u'60dc77af-f8ba-4104-98fa-3e730bcb78fa', u'type': u'gnocchi_resources_threshold', u'comparison_operator': u'lt', u'granularity': 60}]}]}


def _parse_composite_rule(rule):
    """Parse the composite rule.

     The composite rule is assembled by sub threshold rules with 'and',
     'or', the form can be nested. e.g. the form of composite rule can be
     like this:
     {
         "and": [threshold_rule0, threshold_rule1,
                 {'or': [threshold_rule2, threshold_rule3,
                         threshold_rule4, threshold_rule5]}]
     }
     """
    if (isinstance(rule, dict) and len(rule) == 1
        and list(rule)[0] in ('and', 'or')):
        and_or_key = list(rule)[0]
        rules = []
        for r in rule[and_or_key]:
          rules.extend(_parse_composite_rule(r))
        return rules
    else:
        return [rule]


if __name__ == '__main__':
    rules=_parse_composite_rule(a)
    print len(rules)
    print rules
