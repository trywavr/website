/// <reference types="handoff" />

export type BuffersPrefetched = void & { _: 'BuffersPrefetched' };
export type DemoInitialized = void & { _: 'DemoInitialized' };
export type DemoStarted = void & { _: 'DemoStarted' };
export function prefetch(): BuffersPrefetched;
export function startUsingPrefetch(logger: (txt: string) => () => void): (
	buffersPrefetched: BuffersPrefetched
) => () => Promise<{
	demoStarted: DemoStarted;
	demoInitialized: DemoInitialized;
}>;
export function send(
	demoInitialized: DemoInitialized
): (event: any) => () => void;
export function stop(demoStarted: DemoStarted): () => void;
