type DemoInitialized = void & {_: 'DemoInitialized'}
type DemoStarted = void & {_: 'DemoStarted'}

declare module 'handoff' {
  export function initialize(): Promise<DemoInitialized>;
  export function start(logger: (txt: string) => () => void): (demoInitialized: DemoInitialized) => () => Promise<DemoStarted>
  export function send(demoInitialized: DemoInitialized): (event: any) => () => void
  export function stop(demoStarted: DemoStarted): () => void
}