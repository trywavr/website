import React, { useEffect, useState } from 'react';
import { styled } from '@stitches/react';
import { useRouter } from 'next/router';
import {
	AnimatedHeading,
	Step0,
	Step2,
	Step3,
	Step4,
	Step5,
	Step6,
	Step7,
} from '@components/demo';
import {
	startUsingPrefetch,
	send,
	prefetch,
	BuffersPrefetched,
	DemoInitialized,
	DemoStarted,
} from '../utils/wags/handoff';
import { Button, Dialog, DialogContent, Text } from '@components/index';

const Container = styled('div', {
	height: '80vh',
	display: 'flex',
	flexDirection: 'column',
	justifyContent: 'space-between',
	maxWidth: '600px',
	margin: '40px auto 0 auto',
});

type DIDS = { demoStarted: DemoStarted; demoInitialized: DemoInitialized };

const Demo = () => {
	const [buffersPrefetched] = useState<BuffersPrefetched>(prefetch);
	const router = useRouter();
	const [demoInitialized, setDemoInitialized] =
		useState<DemoInitialized | void>();
	const [demoStarted, setDemoStarted] = useState<DemoStarted | void>();
	const queryKey = 'stepNumber';
	const stepNumber =
		router.query[queryKey] ||
		router.asPath.match(new RegExp(`[&?]${queryKey}=(.*)(&|$)`));
	const [dialogSeen, setDialogSeen] = useState<boolean>(false);
	const stepQueryParams =
		stepNumber && typeof stepNumber === 'string'
			? parseInt(stepNumber)
			: stepNumber instanceof Array
			? parseInt(stepNumber[1])
			: undefined;
	const [step, setStep] = useState<number>(stepQueryParams || 0);
	const [dialogOpen, setDialogOpen] = useState(step !== 0 && !dialogSeen);
	useEffect(() => {
		prefetch();
	}, [null]);
	useEffect(() => {
		setStep(stepQueryParams || 0);
	}, [stepNumber, stepQueryParams]);

	const stepToSend = (di: DemoInitialized) => (stp: number) =>
		stp === 0
			? send(di)({
					tag: "DE'Music_was_never_meant_to_be_static_or_fixed",
			  })()
			: stp === 1
			? send(di)({
					tag: "DE'Music_must_explode_with_possibilities",
			  })()
			: stp === 2
			? send(di)({
					tag: "DE'The_possibility_to_add_new_sounds",
					event: { one: true, two: true, three: true, four: true },
			  })()
			: stp === 3
			? send(di)({
					tag: "DE'The_possibility_to_take_a_sound_in_a_new_direction",
					event: {
						check: false,
						choice: "NDC'C1",
						slider: 0.5,
					},
			  })()
			: stp === 4
			? send(di)({
					tag: "DE'The_possibility_to_change_a_beat",
					event: "BC'C1",
			  })()
			: stp === 5
			? send(di)({
					tag: "DE'The_possibility_to_harmonize",
					event: "H'Add_one",
			  })()
			: stp === 6
			? send(di)({
					tag: "DE'The_possibility_to_glitch_crackle_and_shimmer",
					event: false,
			  })()
			: stp === 7
			? send(di)({
					tag: "DE'The_possibility_to_shape_it_with_a_gesture",
					event: { x: 0.5, y: 0.5 },
			  })()
			: stp === 8
			? send(di)({
					tag: "DE'Music_must_explode_with_possibilities_2",
			  })()
			: 0;

	return (
		<Container>
			<div>
				<Dialog
					open={dialogOpen}
					onOpenChange={() => setDialogOpen(!dialogOpen)}
				>
					<DialogContent>
						<Text>
							This demo of wavr requires audio, please make sure your device is
							unmuted. For the best experience, please use headphones!
						</Text>
						<div
							style={{
								display: 'flex',
								justifyContent: 'flex-end',
								marginTop: 16,
							}}
						>
							<Button
								size="2"
								onClick={() => {
									startUsingPrefetch((s: string) => () => console.error(s))(
										buffersPrefetched
									)().then(
										({ demoStarted, demoInitialized }: DIDS) => {
											setDemoInitialized(demoInitialized);
											setDemoStarted(demoStarted);
											stepToSend(demoInitialized)(step);
										},
										(err: Error) => console.error(err)
									);
									setDialogSeen(true);
									setDialogOpen(false);
								}}
							>
								Okay
							</Button>
						</div>
					</DialogContent>
				</Dialog>

				{step === 0 && (
					<>
						<AnimatedHeading text="Peek into what's possible" />
						<Step0
							onClick={() =>
								startUsingPrefetch((s: string) => () => console.error(s))(
									buffersPrefetched
								)().then(
									({ demoStarted, demoInitialized }: DIDS) => {
										setDemoInitialized(demoInitialized);
										setDemoStarted(demoStarted);
										stepToSend(demoInitialized)(1);
									},
									(err: Error) => console.error(err)
								)
							}
							setStep={setStep}
						/>
					</>
				)}
				{step === 1 && (
					<>
						<AnimatedHeading
							text="Music was never meant to be static or fixed."
							lineTwo="Music must explode with possibilities."
						/>
					</>
				)}
				{step === 2 && demoInitialized && (
					<>
						<AnimatedHeading text="The possibility to add and remove sounds..." />
						<Step2 demoInitialized={demoInitialized} />
					</>
				)}
				{step === 3 && demoInitialized && (
					<>
						<AnimatedHeading text="The possibility to take a sound in a new direction..." />
						<Step3 demoInitialized={demoInitialized} />
					</>
				)}
				{step === 4 && demoInitialized && (
					<>
						<AnimatedHeading text="The possibility to change a beat..." />
						<Step4 demoInitialized={demoInitialized} />
					</>
				)}
				{step === 5 && demoInitialized && (
					<>
						<AnimatedHeading text="The possibility to introduce harmony..." />
						<Step5 demoInitialized={demoInitialized} />
					</>
				)}
				{step === 6 && demoInitialized && (
					<>
						<AnimatedHeading text="The possibility to glitch, crackle and shimmer..." />
						<Step6 demoInitialized={demoInitialized} />
					</>
				)}
				{demoInitialized && step === 7 && (
					<>
						<AnimatedHeading text="The possibility to shape it with a gesture..." />
						<Step7 demoInitialized={demoInitialized} />
					</>
				)}
				{demoInitialized && step === 8 && (
					<>
						<AnimatedHeading text="Music must explode with possibilities, and that's why we're building wavr." />
						<button
							onClick={send(demoInitialized)({
								tag: "DE'And_that's_why_we're_building_wavr",
							})}
						>
							click me to trigger the end
						</button>
					</>
				)}
			</div>

			<div style={{ display: 'flex', justifyContent: 'flex-end' }}>
				{step > 0 && (
					<>
						<Button
							onClick={() => {
								setStep(step - 1);
								router.push(`/demo?stepNumber=${step - 1}`);
							}}
							size={2}
						>
							Back
						</Button>
						<div style={{ width: 16 }} />
					</>
				)}
				{step < 8 && step > 0 && (
					<Button
						size={2}
						onClick={() => {
							step > 0 &&
								demoInitialized &&
								stepToSend(demoInitialized)(step + 1);
							router.push(`/demo?stepNumber=${step + 1}`);
						}}
					>
						Next
					</Button>
				)}
			</div>
		</Container>
	);
};

export default Demo;
