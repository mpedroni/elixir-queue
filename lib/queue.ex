defmodule Queue do
  use GenServer

  # Client

  def start_link(initial_state) when is_list(initial_state) do
    GenServer.start_link(__MODULE__, initial_state)
  end

  def enqueue(pid, element) do
    GenServer.cast(pid, {:enqueue, element})
  end

  def dequeue(pid) do
    GenServer.call(pid, :dequeue)
  end

  # Server (callbacks)

  @impl true
  def init(stack) do
    {:ok, stack}
  end

  @impl true
  def handle_call(:dequeue, _from, [head | tail]) do
    {:reply, head, tail}
  end

  @impl true
  def handle_call(:dequeue, _from, []), do: {:reply, [], []}

  @impl true
  def handle_cast({:enqueue, element}, state) do
    {:noreply, state ++ [element]}
  end
end
