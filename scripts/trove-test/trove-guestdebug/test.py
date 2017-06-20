from trove.guestagent.api import API
from trove.common.strategies.cluster import strategy

def client(manager, context, id):
    cls = strategy.load_guestagent_strategy(manager).guest_client_class
    return cls(context, id)
