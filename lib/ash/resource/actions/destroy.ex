defmodule Ash.Resource.Actions.Destroy do
  @moduledoc "The representation of a `destroy` action"

  defstruct [:type, :name, :primary?, :authorization_steps]

  alias Ash.Authorization.Rule

  @type t :: %__MODULE__{
          type: :destroy,
          name: atom,
          primary?: boolean,
          authorization_steps: list(Rule.t())
        }

  @opt_schema Ashton.schema(
                opts: [
                  primary?: :boolean,
                  authorization_steps: {:list, %Rule{}}
                ],
                defaults: [
                  primary?: false,
                  authorization_steps: []
                ],
                describe: [
                  primary?:
                    "Whether or not this action should be used when no action is specified by the caller.",
                  authorization_steps:
                    "A list of `Ash.Authorization.Rule`s that will be stepped through and applied in order."
                ]
              )

  @doc false
  def opt_schema(), do: @opt_schema

  @spec new(atom, Keyword.t()) :: {:ok, t()} | {:error, term}
  def new(name, opts \\ []) do
    case Ashton.validate(opts, @opt_schema) do
      {:ok, opts} ->
        {:ok,
         %__MODULE__{
           name: name,
           type: :destroy,
           primary?: opts[:primary?],
           authorization_steps: opts[:authorization_steps]
         }}

      {:error, error} ->
        {:error, error}
    end
  end
end
