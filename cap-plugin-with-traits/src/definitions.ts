export interface PluginWithTraitsPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
