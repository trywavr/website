import React, { useEffect, useState } from 'react';
import { styled } from '@stitches/react';
import { useRouter } from 'next/router';
import { Step0, Step2, Step3 } from '../components/demo';
import { Button } from '../components/button';
import { AnimatedHeading } from '../components/demo/animated-heading';
// @ts-ignore
import { initialize, start, stop, send } from '../utils/wags/handoff';

const Container = styled('div', {
	height: '80vh',
	display: 'flex',
	flexDirection: 'column',
	justifyContent: 'space-between',
	maxWidth: '600px',
	margin: '40px auto 0 auto',
});

const Demo = () => {
	const router = useRouter();
	const [demoInitialized, setDemoInitialized] =
		useState<DemoInitialized | void>();
	const [demoStarted, setDemoStarted] = useState<DemoStarted | void>();
	const { stepNumber } = router.query;
	const stepQueryParams =
		stepNumber && typeof stepNumber === 'string'
			? parseInt(stepNumber)
			: undefined;
	const [step, setStep] = useState<number>(stepQueryParams || 0);

	useEffect(() => {
		setStep(stepQueryParams || 0);
	}, [stepNumber]);

	const startExample = async () => {
		demoStarted && stop(demoStarted)();
		if (demoInitialized) {
			await start((s: string) => () => console.error(s))(
				demoInitialized
			)().then(setDemoStarted);
			send(demoInitialized)({
				tag: "DE'Music_was_never_meant_to_be_static_or_fixed",
			})();
		} else {
			console.error('Initialization not done yet');
		}
	};
	return (
		<Container>
			<div>
				{step === 0 && (
					<>
						<AnimatedHeading text="Peek into what's possible" />
						<Step0 />
					</>
				)}
				{step === 1 && (
					<>
						<AnimatedHeading
							text="Music was never meant to be static or fixed."
							lineTwo="Music must explode with possibilities."
						/>
						<Button onClick={startExample} size="3" variant="transparentWhite">
							Make sound
						</Button>
					</>
				)}
				{step === 2 && demoInitialized && (
					<>
						<AnimatedHeading text="The possibility to add new sounds..." />
						<Step2 demoInitialized={demoInitialized} />
					</>
				)}
				{step === 3 && (
					<>
						<AnimatedHeading text="The possibility to take a sound in a new direction..." />
						<Step3 />
					</>
				)}
				{step === 4 && (
					<>
						<AnimatedHeading text="The possibility to change a beat..." />
						{/* <Step4 /> */}
					</>
				)}
				{step === 5 && (
					<>
						<AnimatedHeading text="The possibility to introduce harmony..." />
						{/* <Step5 /> */}
					</>
				)}
				{step === 6 && (
					<>
						<AnimatedHeading text="The possibility to glitch, crackle and shimmer..." />
						{/* <Step6 /> */}
					</>
				)}
				{step === 7 && (
					<>
						<AnimatedHeading text="The possibility to shape it with a gesture..." />
						{/* <Step7 /> */}
					</>
				)}
				{step === 8 && (
					<>
						<AnimatedHeading text="The possibility to bring listeners to uncharted musical territory..." />
						{/* <Step8 /> */}
					</>
				)}
				{step === 9 && (
					<>
						<AnimatedHeading text="And the possibility to bring them back again." />
						{/* <Step9 /> */}
					</>
				)}
				{step === 10 && (
					<>
						<AnimatedHeading text="Music must explode with possibilities, and that's why we're building wavr." />
					</>
				)}
			</div>

			<div style={{ display: 'flex', justifyContent: 'flex-end' }}>
				{step > 0 && (
					<>
						<Button onClick={() => setStep(step - 1)} size={2}>
							Back
						</Button>
						<div style={{ width: 16 }} />
					</>
				)}
				{step < 10 && (
					<Button
						size={2}
						onClick={() => {
							step === 0 &&
								initialize().then(
									(res: DemoInitialized) => setDemoInitialized(res),
									(err: Error) => console.log(err)
								);
							step === 1 &&
								send(demoInitialized)({
									tag: "DE'The_possibility_to_add_new_sounds",
									event: { one: false, two: false, three: false, four: false },
								})();
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
