/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


const searchBox = document.getElementById("search-box");
const searchInput = document.getElementById("search-input");
const wordTxt = document.getElementById("word-txt");
const typeTxt = document.getElementById("type-txt");
const phoneticTxt = document.getElementById("phonetic-txt");
const soundBtn = document.getElementById("sound-btn");
const definitionTxt = document.getElementById("definition-txt");

const exampleElem = document.getElementById("example-elem");
const synonymsElem = document.getElementById("synonyms-elem");
const antonymsElem = document.getElementById("antonyms-elem");

const wordDetailsCard = document.querySelector(".word-details");
const errTxt = document.querySelector(".errTxt");

const audio = new Audio();


const pickRichestmeaning = (meanings) => {
    if (!Array.isArray(meanings) || meanings.length === 0) {
        return null;
    }

    const score = m =>
        (m.definitions?.length ?? 0) +
                (m.synonyms?.length ?? 0) +
                (m.antonyms?.length ?? 0) +
                ((m.definitions ?? []).some(d => d?.example?.trim()) ? 2 : 0);
    //      .some duyet mang tra ve true neu co it nhat 1 phan tu thao man dieu kien
    return meanings.reduce((best, cur) => score(cur) > score(best) ? cur : best, meanings[0]);

};

const show = el => el.classList.remove("d-none");
const hide = el => el.classList.add("d-none")


async function getWordInformation(word) {
    const url = `https://api.dictionaryapi.dev/api/v2/entries/en/${word}`;

    const response = await fetch(url);
    if (!response.ok) {
        throw new Error(response.status);
    }
    const data = await response.json();
    const wordData = data[0];
    const phonetics = wordData.phonetics || [];

    let phoneticText = "";
    let phoneticAudio = "";

    for (const p of phonetics) {
        if (p.text && !phoneticText) {
            phoneticText = p.text;
        }
        if (p.audio && !phoneticAudio) {
            phoneticAudio = p.audio;
        }
        if (phoneticText && phoneticAudio) {
            break;
        }
    }

    const meanings = wordData.meanings;
    const meaning = pickRichestmeaning(meanings);
    return{
        word: word.toLowerCase(),
        phonetic: {
            text: phoneticText,
            audio: phoneticAudio
        },
        speechPart: meaning.partOfSpeech,
        definition: meaning.definitions[0].definition,
        synonyms: meaning.synonyms,
        antonyms: meaning.antonyms,
        example: meaning.definitions[0].example || ""
    }
}

searchBox.addEventListener('submit', async e => {
    e.preventDefault();

    const input = searchInput.value.trim();
    errTxt.textContent = "";
    hide(errTxt);
    hide(wordDetailsCard);

    if (!input) {
        errTxt.textContent = "Vui lòng nhập từ vựng cần tra";
        show(errTxt);
        return;
    }
    try {
        const info = await getWordInformation(input);
        wordTxt.textContent = info.word;
        typeTxt.textContent = info.speechPart || "";
        phoneticTxt.textContent = info.phonetic.text || "";
        audio.src = info.phonetic.audio || "";
        definitionTxt.textContent = info.definition || "";

        const exa = exampleElem.querySelector('p');
        exa.textContent = info.example || "";
        info.example ? show(exampleElem) : hide(exampleElem);

        const syn = synonymsElem.querySelector("p");
        syn.textContent = (info.synonyms ?? []).join(", ");
        (info.synonyms ?? []).length ? show(synonymsElem) : hide(synonymsElem);

        const ant = antonymsElem.querySelector("p");
        ant.textContent = (info.antonyms ?? []).join(", ");
        (info.antonyms ?? []).length ? show(antonymsElem) : hide(antonymsElem);
        show(wordDetailsCard);

        document.getElementById("input-word").value = info.word;
        document.getElementById("input-phonetic").value = info.phonetic.text;
        document.getElementById("input-audio-url").value = info.phonetic.audio;
        document.getElementById("input-part-of-speech").value = info.speechPart;
        document.getElementById("input-definition").value = info.definition;
        document.getElementById("input-example").value = info.example || "";
        document.getElementById("input-synonyms").value = (info.synonyms || []).join(";");
        document.getElementById("input-antonyms").value = (info.antonyms || []).join(";");

    } catch (e) {
        errTxt.textContent = "Không tìm thấy từ";
        show(errTxt);
    }
});

soundBtn.addEventListener('click', () => {
    if (audio.src) {
        audio.play();
    }
})



